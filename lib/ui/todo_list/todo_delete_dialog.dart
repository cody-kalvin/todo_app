import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';

class TodoDeleteDialog extends StatelessWidget {
  final Todo todo;

  const TodoDeleteDialog({
    this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Delete'),
      content: Text(
        'Are you sure you want to delete ${todo.description}?',
      ),
      actions: [
        CupertinoDialogAction(
          child: Text('Yes'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        CupertinoDialogAction(
          child: Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
