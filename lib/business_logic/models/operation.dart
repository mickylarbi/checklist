// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:checklist/business_logic/enums/task_status.dart';
import 'package:checklist/business_logic/models/chat.dart';

class Operation {
  Op op;
  String? id;
  String? title;
  String? description;
  DateTime? dueDate;
  TaskStatus? status;

  Operation({
    required this.op,
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.status,
  });

  Operation copyWith({
    Op? op,
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
  }) {
    return Operation(
      op: op ?? this.op,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'op': op.name,
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toString(),
      if (status != null) 'status': status?.name,
    };
  }

  factory Operation.fromMap(Map<String, dynamic> map) {
    return Operation(
      op: Op.values.byName(map['op'] as String),
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      dueDate: DateTime.tryParse(map['dueDate']),
      status:
          map['status'] != null
              ? TaskStatus.values.byName(map['status'] as String)
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Operation.fromJson(String source) =>
      Operation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Operation(op: $op, id: $id, title: $title, description: $description, dueDate: $dueDate, status: $status)';
  }

  @override
  bool operator ==(covariant Operation other) {
    if (identical(this, other)) return true;

    return other.op == op &&
        other.id == id &&
        other.description == description &&
        other.dueDate == dueDate &&
        other.status == status;
  }

  @override
  int get hashCode {
    return op.hashCode ^
        id.hashCode ^
        description.hashCode ^
        dueDate.hashCode ^
        status.hashCode;
  }
}
