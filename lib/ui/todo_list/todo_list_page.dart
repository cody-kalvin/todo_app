import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/notification/todo_notification.dart';
import 'package:todo_app/provider/todo_store_model.dart';
import 'package:todo_app/ui/todo_list/todo_delete_dialog.dart';
import 'package:todo_app/ui/todo_list/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TodoNotification notificationManager = TodoNotification();

  @override
  void initState() {
    super.initState();
    notificationManager.initialize(onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To do list'),
        centerTitle: false,
      ),
      body: Consumer<TodoStoreModel>(
        builder: (context, storeModel, child) {
          return FutureBuilder<List<Todo>>(
            future: storeModel.repository?.getActive(),
            builder: (context, snapshot) {
              final todos = snapshot.data ?? [];

              notificationManager.cancelAll();
              notificationManager.send(todos);

              if (todos.isNotEmpty) {
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Dismissible(
                      key: Key(todo.id.toString()),
                      background: Container(
                        color: Colors.red,
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) => TodoDeleteDialog(
                            todo: todo,
                          ),
                        );
                      },
                      onDismissed: (direction) async {
                        await storeModel.repository.delete(todo);
                        notificationManager.cancel(todo.id);
                        setState(() {
                          todos.remove(todo);
                        });
                        storeModel.refresh();
                      },
                      child: TodoListItem(
                        todo: todo,
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('Nothing to do.'),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          '/write',
          arguments: null,
        ),
        tooltip: 'Add totdo',
        child: Icon(Icons.add),
      ),
    );
  }

  Future onSelectNotification(String payload) async {
    final todo = Todo.fromJson(jsonDecode(payload) as Map<String, dynamic>);
    await Navigator.of(context).pushNamed(
      '/write',
      arguments: todo,
    );
  }
}
