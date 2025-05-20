// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:checklist/business_logic/enums/task_status.dart';

class Task {
  String? id;
  String title;
  String? description;
  DateTime dateTime;
  TaskStatus status;
  DateTime createdAt;
  DateTime? updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dateTime,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  Task.newTask({
    required this.title,
    this.description,
    required this.dateTime,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  }) : id = null;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'dateTime': dateTime.toString(),
      'status': status.name,
      'createdAt': createdAt.toString(),
      if (updatedAt != null) 'updatedAt': updatedAt.toString(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      dateTime: DateTime.parse(map['dateTime']),
      status: TaskStatus.values.byName((map['status'] as String)),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? ''),
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, dateTime: $dateTime, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.dateTime == dateTime &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        dateTime.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
