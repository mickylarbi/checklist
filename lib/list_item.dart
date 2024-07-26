import 'package:hive_flutter/hive_flutter.dart';

part 'list_item.g.dart';

@HiveType(typeId: 1)
class ListItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isCompleted;

  ListItem({
    required this.name,
    required this.isCompleted,
  });

  ListItem copyWith({
    String? name,
    bool? isCompleted,
  }) {
    return ListItem(
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
