import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/task.dart';
import './task_edit.dart';
import './task_create.dart';
import '../services/task_service.dart';
import './auth_page.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> _tasks;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tasks = [];
    _initializeUserSession().then((isLoggedIn) {
      if (isLoggedIn) {
        fetchTasks();
      } else {
        _redirectToAuth();
      }
    });
  }

  Future<bool> _initializeUserSession() async {
    try {
      final currentUser = await ParseUser.currentUser() as ParseUser?;
      if (currentUser != null) {
        final sessionToken = currentUser.get<String>('sessionToken');
        if (sessionToken != null && sessionToken.isNotEmpty) {
          // Session is valid
          return true;
        }
      }
      return false; // No valid session
    } catch (e) {
      print('Error during session initialization: $e');
      return false;
    }
  }

  void _redirectToAuth() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = await ParseUser.currentUser() as ParseUser?;
      if (currentUser != null) {
        await currentUser.logout();
      }
      _redirectToAuth();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await TaskService().fetchTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (e) {
      print("Failed to fetch tasks");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = task..isCompleted = !task.isCompleted;

    try {
      await updatedTask.save();
      setState(() {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = updatedTask;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating task: $e')),
      );
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await task.delete();
      setState(() {
        _tasks.removeWhere((t) => t.id == task.id);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); // Example format: 2024-12-03
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Logout user
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text("No tasks available."))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text('Due: ${formatDate(task.dueDate)}'),
                      trailing: IconButton(
                        icon: Icon(
                          task.isCompleted
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                        ),
                        onPressed: () => toggleTaskStatus(task),
                      ),
                      onLongPress: () => deleteTask(task),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditTaskScreen(task: task)),
                        );
                        fetchTasks();
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
          fetchTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
