import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/task.dart';

class TaskService {
  Future<List<Task>> fetchTasks() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      throw Exception('No user is logged in.');
    }

    final query = QueryBuilder(ParseObject('Task'))
      ..whereEqualTo('user', currentUser.toPointer());
    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!
          .map((e) => Task.fromParse(e as ParseObject))
          .toList();
    } else {
      throw Exception(response.error?.message ?? 'Failed to fetch tasks.');
    }
  }

  Future<void> createTask(Task task) async {
    await task.save();
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    if (task.id == null) {
      throw Exception('Cannot update a task without an ID.');
    }

    try {
      final parseObject = task.toParse();
      final response = await parseObject.save();
      if (!response.success) {
        throw Exception('Failed to update task: ${response.error?.message}');
      }
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  // Delete a task
  Future<void> deleteTask(Task task) async {
    try {
      await task.delete();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}
