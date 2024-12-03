import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _selectedDate = widget.task.dueDate;
  }

  // Save the edited task
  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a valid title and due date')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      widget.task.title = _titleController.text;
      widget.task.dueDate = _selectedDate!;
      await widget.task.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task updated successfully')),
      );
      Navigator.pop(context); // Navigate back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Open the date picker to select a new due date
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); // Example format: 2024-12-03
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title Input
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Task Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Due Date Picker
                    TextButton.icon(
                      onPressed: () => _selectDueDate(context),
                      icon: Icon(Icons.calendar_today),
                      label: Text(
                        _selectedDate == null
                            ? 'Select Due Date'
                            : 'Due Date: ${DateFormat('MMM d, yyyy').format(_selectedDate!)}',
                      ),
                    ),
                    SizedBox(height: 16),

                    // Save Button
                    ElevatedButton(
                      onPressed: _saveTask,
                      child: Text("Save Task"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
