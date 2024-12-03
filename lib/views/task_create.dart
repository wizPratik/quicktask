import 'package:flutter/material.dart';
import 'package:quicktask/models/task.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

  // Handle task saving to the database
  Future<void> _saveTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text;
      if (_selectedDate != null) {
        final task = Task(title: title, dueDate: _selectedDate!);
        final parseObject = task.toParse();

        final response = await parseObject.save();

        if (response.success) {
          // Successfully saved task, show success message and pop page
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Task added successfully')));
          Navigator.pop(context); // Go back to the previous screen (task list)
        } else {
          // Show error message if saving fails
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to add task')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please select a due date')));
      }
    }
  }

  // Open the date picker to select due date
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title Input
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Due Date Picker
              TextButton(
                onPressed: () => _selectDueDate(context),
                child: Text(
                  _selectedDate == null
                      ? 'Select Due Date'
                      : 'Due Date: ${_selectedDate!.toLocal()}'
                          .split(' ')[0], // Formatting date
                ),
              ),
              SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
