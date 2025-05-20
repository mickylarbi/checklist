import 'dart:convert';
import 'dart:developer';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:checklist/business_logic/cubits/task/task_cubit.dart';
import 'package:checklist/business_logic/models/chat.dart';
import 'package:checklist/business_logic/models/operation.dart';
import 'package:checklist/business_logic/models/task.dart';
import 'package:checklist/business_logic/services/db_service.dart';
import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:toastification/toastification.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.taskCubit});

  final TaskCubit taskCubit;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatNotifier = ValueNotifier<List<Chat>>([]);

  final uri = Uri.https(authority, 'chat');

  Future<void> sendMessage(String message, {bool first = false}) async {
    if (!first) {
      chatNotifier.value = [
        ...chatNotifier.value,
        Chat(message: message, sender: Sender.user, sentAt: DateTime.now()),
      ];
    }

    final body = jsonEncode({
      "history": chatNotifier.value.map((e) => e.toMap()).toList(),
      "tasks": await DBService().getItems(),
      "message": message,
    });

    final response = await post(
      uri,
      body: body,
      headers: {'Content-Type': 'application/json'},
    );

    log('status code: ${response.statusCode}');
    log('body: ${response.body}');

    if (response.statusCode == 201) {
      Chat chat = Chat.fromMap({
        ...jsonDecode(response.body),
        'sender': Sender.ai.name,
        'sentAt': DateTime.now().toString(),
      });
      chatNotifier.value = [...chatNotifier.value, chat];

      if (chat.operations != null) {
        for (Operation operation in chat.operations!) {
          switch (operation.op) {
            case Op.create:
              widget.taskCubit.addTask(
                Task.fromOperation(operation, DateTime.now(), null),
              );
              break;

            case Op.update:
              Task task = Task.fromMap(
                await DBService().getItem(operation.id ?? '') ?? {},
              ).copyWith(
                dateTime: operation.dueDate,
                description: operation.description,
                title: operation.title,
                status: operation.status,
              );

              widget.taskCubit.editTask(task);
              break;

            case Op.delete:
              Task task = Task.fromMap(
                await DBService().getItem(operation.id ?? '') ?? {},
              );
              widget.taskCubit.deleteTask(task);
              break;
          }
        }
      }
    } else {
      throw Exception(response);
    }
  }

  @override
  void initState() {
    super.initState();

    sendMessage('hi', first: true).catchError((e) {
      log('error: $e');
      showToastNotification(
        context,
        'Unable to connect',
        type: ToastificationType.error,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedAiMagic,
              color: Colors.purple,
            ),
            SizedBox(width: 10),
            Text(
              'AI Assist',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<List<Chat>>(
        valueListenable: chatNotifier,
        builder: (context, value, child) {
          List<Chat> chats = value;
          chats.sort((a, b) => b.sentAt.compareTo(a.sentAt));

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                  reverse: true,
                  itemCount: chats.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    Chat chat = chats[index];

                    return BubbleNormal(
                      text: chat.message,
                      color:
                          chat.sender == Sender.ai
                              ? Colors.grey[100]!
                              : Colors.purple,
                      isSender: chat.sender == Sender.user,
                      textStyle:
                          chat.sender == Sender.user
                              ? const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              )
                              : const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                      padding: EdgeInsets.all(8),
                      leading: HugeIcon(
                        icon: HugeIcons.strokeRoundedAiMagic,
                        color: Colors.purple,
                      ),
                    );
                  },
                ),
              ),
              if (chats.isEmpty ||
                  (chats.isNotEmpty && chats.first.sender == Sender.user))
                SpinKitChasingDots(color: Colors.purple.withAlpha(40)),
              if (chats.isNotEmpty &&
                  chats.first.sender == Sender.ai &&
                  chats.first.suggestedActions?.isNotEmpty == true)
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 40, right: 24),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return OutlinedButton(
                        onPressed: () {
                          sendMessage(
                            chats.first.suggestedActions![index],
                          ).catchError((error) {
                            chatNotifier.value = [
                              ...chatNotifier.value,
                              Chat(
                                sender: Sender.ai,
                                message:
                                    'Something went wrong. Please try again',
                                sentAt: DateTime.now(),
                              ),
                            ];
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: Text(
                          chats.first.suggestedActions?[index] ?? '',
                          style: const TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 10);
                    },
                    itemCount: chats.first.suggestedActions?.length ?? 0,
                  ),
                ),
              SizedBox(height: 10),
              MessageBar(
                onSend: (value) {
                  if (value.isNotEmpty && chats.first.sender == Sender.ai) {
                    sendMessage(value).catchError((e) {
                      showToastNotification(
                        context,
                        'Unable to send message',
                        type: ToastificationType.error,
                      );
                    });
                  }
                },
                messageBarHintText: 'Ask AI✨',
                messageBarColor: Colors.grey[100]!,
                sendButtonColor: Colors.purple,
              ),

              Container(color: Colors.grey[100], height: 40),
            ],
          );
        },
      ),
    );
  }
}
