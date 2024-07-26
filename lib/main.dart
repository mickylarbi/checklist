// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:checklist/list_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ListItemAdapter());
  await Hive.openBox<ListItem>('list');

  runApp(MaterialApp(
    home: const ChecklistScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(),
    darkTheme: ThemeData.dark(),
  ));
}

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist'),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<ListItem>('list').listenable(),
          builder: (context, box, child) {
            return ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                ListItem item = box.values.toList()[index];

                return ListTile(
                  onTap: () {
                    showTheBottomSheet(context, index, box);
                  },
                  title: Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: item.isCompleted ? Colors.green : Colors.grey),
                  ),
                  trailing: item.isCompleted
                      ? const Icon(Icons.done, color: Colors.green)
                      : null,
                  selected: item.isCompleted,
                  selectedTileColor: Colors.green.withOpacity(.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: item.isCompleted
                          ? Colors.green.withOpacity(.01)
                          : Colors.grey.withOpacity(.3),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 20),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add item'),
              content: TextField(
                autofocus: true,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Hive.box<ListItem>('list')
                        .add(ListItem(name: value.trim(), isCompleted: false));
                    Navigator.pop(context);
                  }
                },
                decoration: const InputDecoration(hintText: 'Type here'),
              ),
            ),
          );
        },
        label: const Text('Add item'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<T?> showTheBottomSheet<T>(
      BuildContext context, int index, Box<ListItem> box) {
    ListItem item = box.values.toList()[index];

    return showModalBottomSheet(
      enableDrag: false,
      context: context,
      builder: (context) => BottomSheet(
        enableDrag: false,
        onClosing: () {},
        builder: (context) => Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.withOpacity(.1),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                onTap: () {
                  box.putAt(
                      index, item.copyWith(isCompleted: !item.isCompleted));

                  Navigator.pop(context);
                },
                title: Text(
                  'Mark as ${item.isCompleted ? 'un' : ''}completed',
                  style: TextStyle(
                    color: item.isCompleted ? Colors.yellow[900] : Colors.green,
                  ),
                ),
                trailing: Icon(
                  item.isCompleted ? Icons.clear : Icons.done,
                  color: item.isCompleted ? Colors.yellow[900] : Colors.green,
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24))),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Rename item'),
                      content: TextFormField(
                        autofocus: true,
                        initialValue: item.name,
                        onFieldSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            box.putAt(index, item.copyWith(name: value.trim()));

                            Navigator.pop(context);
                          }
                        },
                        decoration:
                            const InputDecoration(hintText: 'Type here'),
                      ),
                    ),
                  );
                },
                title: const Text('Rename item'),
                splashColor: Colors.transparent,
              ),
              ListTile(
                onTap: () {
                  box.deleteAt(index);
                  Navigator.pop(context);
                },
                title: const Text(
                  'Remove from list',
                  style: TextStyle(color: Colors.red),
                ),
                trailing: const Icon(Icons.delete, color: Colors.red),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(24))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
