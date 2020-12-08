import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;

  const TodoListItem({
    this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.of(context).pushNamed(
            '/write',
            arguments: todo,
          );
        },
        child: ListTile(
          title: Text(
            todo.description,
            style: todo.status == 'done'
                ? TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey.shade700,
                  )
                : TextStyle(
                    color: Colors.red,
                  ),
          ),
          subtitle: Text('${todo.notify} mins'),
        ),
      ),
    );
  }
}
