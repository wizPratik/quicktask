import 'package:flutter/material.dart';
import 'package:quicktask/models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _dueDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _dueDateController =
        TextEditingController(text: widget.task.dueDate.toString());
  }

  Future<void> saveTask() async {
    widget.task.title = _titleController.text;
    widget.task.dueDate = DateTime.parse(_dueDateController.text);
    await widget.task.save();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title")),
            TextField(
                controller: _dueDateController,
                decoration:
                    InputDecoration(labelText: "Due Date (YYYY-MM-DD)")),
            SizedBox(height: 16),
            ElevatedButton(onPressed: saveTask, child: Text("Save Task")),
          ],
        ),
      ),
    );
  }
}
