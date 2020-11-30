import 'package:flutter/foundation.dart';
import 'package:todo_app/data/todo_repository.dart';

class TodoStoreModel with ChangeNotifier {
  final TodoRepository _repository;

  TodoStoreModel(this._repository);

  TodoRepository get repository => _repository;

  void refresh() {
    notifyListeners();
  }
}
