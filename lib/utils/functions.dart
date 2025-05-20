import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

import 'package:checklist/business_logic/models/task.dart';
import 'package:checklist/business_logic/services/db_service.dart';

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String listToCsv(List<Map<String, dynamic>> data) {
  if (data.isEmpty) return '';

  final headers = data.first.keys.toList();
  final csvBuffer = StringBuffer();
  csvBuffer.writeln(headers.join(','));

  for (final row in data) {
    final values = headers
        .map((h) {
          final value = row[h]?.toString() ?? '';
          // Escape double quotes by doubling them, and wrap in quotes if needed
          if (value.contains(',') ||
              value.contains('"') ||
              value.contains('\n')) {
            return '"${value.replaceAll('"', '""')}"';
          }
          return value;
        })
        .join(',');
    csvBuffer.writeln(values);
  }
  return csvBuffer.toString().trim();
}

Future<void> shareCsvBuffer(
  String csvBuffer, {
  String fileName = 'data.csv',
}) async {
  final csvBytes = Uint8List.fromList(utf8.encode(csvBuffer));
  final xfile = XFile.fromData(csvBytes, name: fileName, mimeType: 'text/csv');
  await SharePlus.instance.share(
    ShareParams(
      files: [xfile],
      text: 'Here is your CSV file.',
      title: 'Here is your CSV file.',
    ),
  );
}

/// Converts JSON to CSV and shares it as an in-memory file
// Future<void> shareJsonAsCsv(String jsonString) async {
//   try {
//     final csvString = jsonToCsv(jsonString);
//     final csvBytes = Uint8List.fromList(utf8.encode(csvString));

//     final xfile = XFile.fromData(
//       csvBytes,
//       name: 'data.csv',
//       mimeType: 'text/csv',
//     );

//     await SharePlus.instance.share(
//       ShareParams(files: [xfile], text: 'Here is your CSV file.'),
//     );
//   } catch (e) {
//     log('Error: $e');
//   }
// }

Future<void> backupTasksToFirestore() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('No user logged in');

  // Fetch all tasks from local DB
  final items = await DBService().getItems();
  final tasks = items.map((item) => Task.fromMap(item)).toList();

  // Reference to user's tasks collection in Firestore
  final tasksRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('tasks');

  // Optionally: Clear existing tasks in Firestore before backup
  final snapshot = await tasksRef.get();
  for (final doc in snapshot.docs) {
    await doc.reference.delete();
  }

  // Upload each task
  for (final task in tasks) {
    await tasksRef.doc(task.id).set(task.toMap());
  }
}

Future<void> restoreTasksFromFirestore() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('No user logged in');

  // Reference to user's tasks collection in Firestore
  final tasksRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('tasks');

  // Fetch all tasks from Firestore
  final snapshot = await tasksRef.get();
  final tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();

  // Get existing tasks from local DB as a map of id -> Task
  final localItems = await DBService().getItems();
  final localTasks = {
    for (var item in localItems) item['id']: Task.fromMap(item),
  };

  // Insert or update each task from Firestore based on updatedAt
  for (final cloudTask in tasks) {
    final localTask = localTasks[cloudTask.id];

    if (localTask != null) {
      // Compare updatedAt and keep the most recent
      final cloudUpdatedAt =
          cloudTask.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final localUpdatedAt =
          localTask.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (cloudUpdatedAt.isAfter(localUpdatedAt)) {
        await DBService().updateItem(cloudTask.id!, cloudTask.toMap());
      }
      // else: local is newer or same, do nothing
    } else {
      // Insert new task
      await DBService().insertItem(cloudTask.toMap());
    }
  }
}
