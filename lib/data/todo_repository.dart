import 'package:todo_app/data/sqlite_persistence.dart';
import 'package:todo_app/model/todo.dart';

class TodoRepository {
  final SqlitePersistence _repository;

  static Future<TodoRepository> createFrom(
      {Future<SqlitePersistence> future}) async {
    final repository = await future;
    final ret = TodoRepository(repository);

    return ret;
  }

  TodoRepository(this._repository);

  Future<void> write(Todo todo) async {
    await _repository.upsert(todo.toJson());
  }

  Future<List<Todo>> getActive() async {
    final objects = await _repository.getActive();
    return objects.map((map) => Todo.fromJson(map)).toList();
  }

  Future<List<Todo>> getPending() async {
    final objects = await _repository.getActive();
    return objects.map((map) => Todo.fromJson(map)).toList();
  }

  Future<void> delete(Todo todo) async {
    await _repository.delete(todo.id);
  }
}
