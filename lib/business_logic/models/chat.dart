// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:checklist/business_logic/models/operation.dart';
import 'package:flutter/foundation.dart';

class Chat {
  // String id;
  Sender sender;
  String message;
  List<Operation>? operations;
  List<String>? suggestedActions;
  DateTime sentAt;

  Chat({
    // required this.id,
    required this.sender,
    required this.message,
    this.operations,
    this.suggestedActions,
    required this.sentAt,
  });

  Chat copyWith({
    // String? id,
    Sender? sender,
    String? message,
    List<Operation>? operations,
    List<String>? suggestedActions,
    DateTime? sentAt,
  }) {
    return Chat(
      // id: id ?? this.id,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      operations: operations ?? this.operations,
      suggestedActions: suggestedActions ?? this.suggestedActions,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id,
      'sender': sender.name,
      'message': message,
      if (operations != null)
        'operations': operations?.map((e) => e.toMap()).toList(),
      if (suggestedActions != null) 'suggestedActions': suggestedActions,
      'sendAt': sentAt.toString(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      // id: map['id'] as String,
      sender: Sender.values.byName(map['sender'] as String),
      message: map['message'] as String,
      operations:
          (map['operations'] as List<dynamic>?)
              ?.map((e) => Operation.fromMap(e))
              .toList(),
      suggestedActions:
          (map['suggestedActions'] as List<dynamic>?)?.cast<String>(),
      sentAt: DateTime.parse(map['sentAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(sender:$sender, message: $message, operations: $operations, suggestedActions: $suggestedActions)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return
    //  other.id == id &&
    other.message == message &&
        listEquals(other.operations, operations) &&
        listEquals(other.suggestedActions, suggestedActions);
  }

  @override
  int get hashCode {
    return
    //  id.hashCode ^
    message.hashCode ^ operations.hashCode ^ suggestedActions.hashCode;
  }
}

enum Op { create, update, delete }

enum Sender { ai, user }
