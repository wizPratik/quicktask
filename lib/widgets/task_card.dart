import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final DateTime dueDate;
  final bool isComplete;
  final Function(bool) onToggle;

  TaskCard({
    required this.title,
    required this.dueDate,
    required this.isComplete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('Deadline: $dueDate'),
      trailing: Switch(
        value: isComplete,
        onChanged: onToggle,
      ),
    );
  }
}
