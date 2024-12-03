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

  ParseObject toParse() {
    final parseObject = ParseObject('Task')
      ..set('title', title)
      ..set('dueDate', dueDate)
      ..set('isCompleted', isCompleted);
    if (id != null) {
      parseObject.objectId = id;
    }
    return parseObject;
  }

  Task.fromParse(ParseObject object)
      : id = object.objectId,
        title = object.get<String>('title') ?? '',
        dueDate = object.get<DateTime>('dueDate') ?? DateTime.now(),
        isCompleted = object.get<bool>('isCompleted') ?? false;

  Future<void> save() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      final parseObject = toParse()..set('user', currentUser.toPointer());
      final response = await parseObject.save();
      if (!response.success) {
        throw Exception('Failed to save task: ${response.error?.message}');
      }
    } else {
      throw Exception('No user logged in.');
    }
  }

  Future<void> delete() async {
    final response = await toParse().delete();
    if (!response.success) {
      throw Exception('Failed to delete task: ${response.error?.message}');
    }
  }
}
