import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/model/todo.dart';

class TodoNotification {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  void initialize(SelectNotificationCallback onSelectCallback) {
    final androidInit = const AndroidInitializationSettings('app_icon');
    final iOSInit = const IOSInitializationSettings();
    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );
    _plugin.initialize(
      initSettings,
      onSelectNotification: onSelectCallback,
    );
  }

  void cancel(int id) async {
    await _plugin.cancel(id);
  }

  void cancelAll() async {
    await _plugin.cancelAll();
  }

  void send(List<Todo> todos) async {
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
        await _build(todos[i]);
      }
    }
  }

  Future<void> _build(Todo todo) async {
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

    await _plugin.zonedSchedule(
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
