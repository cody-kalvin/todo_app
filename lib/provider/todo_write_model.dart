import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:uuid/uuid.dart';

class TodoWriteModel with ChangeNotifier {
  final int _id;

  String _description;

  bool _isDone;

  String _preview;

  int _notify;

  final DateTime _createdOn;

  TodoWriteModel({
    Todo todo,
  })  : _id = todo != null ? todo.id : Uuid().v1().hashCode,
        _description = todo != null ? todo.description : '',
        _isDone = todo != null ? todo.status == 'done' : false,
        _preview = todo != null ? todo.preview : '',
        _notify = todo != null ? todo.notify : 0,
        _createdOn = todo != null ? todo.createdOn : DateTime.now();

  String get description {
    return _description;
  }

  bool get isDone {
    return _isDone;
  }

  String get preview {
    return _preview;
  }

  int get notify {
    return _notify;
  }

  DateTime get createdOn {
    return _createdOn;
  }

  bool get isValid {
    return _description.isNotEmpty && [5, 10].contains(_notify);
  }

  Todo get data {
    return Todo(
      id: _id.hashCode,
      description: _description,
      status: _isDone ? 'done' : 'pending',
      preview: _preview,
      notify: _notify,
      createdOn: _createdOn,
    );
  }

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void setDone(bool value) {
    _isDone = value;
    notifyListeners();
  }

  void toggleStatus() {
    _isDone = !_isDone;
    notifyListeners();
  }

  void setPreview(String value) {
    _preview = value;
    notifyListeners();
  }

  void setNotify(int value) {
    _notify = value;
    notifyListeners();
  }
}
