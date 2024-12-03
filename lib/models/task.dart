import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  String? id;
  String title;
  DateTime dueDate;
  bool isCompleted;

  Task(
      {this.id,
      required this.title,
      required this.dueDate,
      this.isCompleted = false});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }

  Task.fromParse(ParseObject object)
      : id = object.objectId,
        title = object.get<String>('title') ?? '',
        dueDate = object.get<DateTime>('dueDate') ?? DateTime.now(),
        isCompleted = object.get<bool>('isCompleted') ?? false;

  ParseObject toParse() {
    final parseObject = ParseObject('Task')
      ..set('title', title)
      ..set('dueDate', dueDate);
    return parseObject;
  }

  Future<void> save() async {
    final parseObject = ParseObject('Task')
      ..set('title', title)
      ..set('dueDate', dueDate)
      ..set('isCompleted', isCompleted);

    if (id == null) {
      await parseObject.save();
    } else {
      parseObject.objectId = id;
      await parseObject.save();
    }
  }

  Future<void> delete() async {
    final parseObject = ParseObject('Task')..objectId = id;
    await parseObject.delete();
  }
}
