import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quicktask/models/task.dart';
import 'task_edit.dart';
import 'task_create.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = [];
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final query = QueryBuilder(ParseObject('Task'));
    final ParseResponse response = await query.query();

    if (response.success && response.results != null) {
      setState(() {
        _tasks = response.results!
            .map<Task>((e) => Task.fromParse(e as ParseObject))
            .toList();
      });
    } else {
      print('Failed to fetch tasks: ${response.error?.message}');
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted;
    await task.save();
    fetchTasks();
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tasks")),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.dueDate.toString()),
            trailing: IconButton(
              icon: Icon(task.isCompleted
                  ? Icons.check_circle
                  : Icons.check_circle_outline),
              onPressed: () => toggleTaskStatus(task),
            ),
            onLongPress: () => deleteTask(task),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTaskPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
