import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TaskService {
  Future<List<ParseObject>> fetchTasks() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    final query = QueryBuilder(ParseObject('Task'))
      ..whereEqualTo('user', currentUser);
    final response = await query.query();
    return response.success ? response.results as List<ParseObject> : [];
  }

  Future<void> createTask(String subject, DateTime deadline, bool state) async {
    final task = ParseObject('Task')
      ..set('subject', subject)
      ..set('deadline', deadline)
      ..set('state', state)
      ..set('user', await ParseUser.currentUser());
    await task.save();
  }
}
