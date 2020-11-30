import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/todo_repository.dart';
import 'package:todo_app/provider/todo_store_model.dart';
import 'package:todo_app/provider/todo_write_model.dart';
import 'package:todo_app/ui/todo/todo_list_page.dart';
import 'package:todo_app/ui/todo/todo_write_page.dart';

import 'data/sqlite_persistence.dart';
import 'model/todo.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  static var store = TodoStoreModel(null);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TodoRepository.createFrom(
        future: SqlitePersistence.create(),
      ),
      builder: (context, snapshot) {
        final repository = snapshot.data;
        store = TodoStoreModel(repository as TodoRepository);

        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: store,
            ),
          ],
          child: MaterialApp(
            title: 'Todo App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade700,
                    width: 1,
                  ),
                ),
              ),
            ),
            home: TodoListPage(),
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) {
                  return _buildRoute(
                    context: context,
                    routeName: settings.name,
                    arguments: settings.arguments,
                  );
                },
                maintainState: true,
                fullscreenDialog: false,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRoute({
    @required BuildContext context,
    @required String routeName,
    Object arguments,
  }) {
    switch (routeName) {
      case '/list':
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: store,
            ),
          ],
          child: TodoListPage(),
        );
      case '/write':
        TodoWriteModel write;
        if (arguments is Todo) {
          write = TodoWriteModel(
            todo: arguments,
          );
        } else {
          write = TodoWriteModel();
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: store,
            ),
            ChangeNotifierProvider.value(
              value: write,
              // value: write,
            )
          ],
          child: TodoWritePage(),
        );
      default:
        return Container();
    }
  }
}
