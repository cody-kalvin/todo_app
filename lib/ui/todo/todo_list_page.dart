import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/provider/todo_store_model.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    final initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );

    final initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _storeModel = Provider.of<TodoStoreModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('To do list'),
        centerTitle: false,
      ),
      body: FutureBuilder<List<Todo>>(
        future: _storeModel.repository?.getActive(),
        builder: (context, snapshot) {
          final todos = snapshot.data ?? [];

          _sendNotifications(todos);

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
                      builder: (BuildContext context) => CupertinoAlertDialog(
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
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    await _storeModel.repository.delete(todo);
                    await notificationsPlugin.cancel(todo.id);
                    setState(() {
                      todos.remove(todo);
                    });
                  },
                  child: Card(
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

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    final todo = Todo.fromJson(json.decode(payload) as Map<String, dynamic>);

    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(payload),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.of(context).pushNamed(
                '/write',
                arguments: todo,
              );
            },
          ),
        ],
      ),
    );
  }

  void _sendNotifications(List<Todo> todos) async {
    await notificationsPlugin.cancelAll();

    await tz.initializeTimeZones();

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime skd;

    for (var i = 0; i < todos.length; i++) {
      skd = tz.TZDateTime.from(
        todos[i].createdOn.add(Duration(minutes: todos[i].notify)),
        tz.local,
      );
      if (todos[i].status == 'pending' &&
          now.millisecondsSinceEpoch < skd.millisecondsSinceEpoch) {
        await _buildNotification(todos[i]);
      }
    }
  }

  Future<void> _buildNotification(Todo todo) async {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'alarms',
      'Alarms',
      'Alarms for your to do list',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'To do',
    );

    final iOSChannelSpecifics = IOSNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iOSChannelSpecifics,
    );

    await notificationsPlugin.zonedSchedule(
      todo.id,
      todo.description,
      todo.status,
      tz.TZDateTime.from(
        todo.createdOn.add(Duration(minutes: todo.notify)),
        tz.local,
      ),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: jsonEncode(todo),
    );
  }
}
