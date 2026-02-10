import 'package:sregep_productivity_app/data/database_helper.dart';

class TodoRepository {
  final _dbService = DatabaseService.instance;

  Future<int> insertTodo(Map<String, dynamic> row) async {
    final db = await _dbService.database;
    return await db.insert("todos", row);
  }

  Future<List<Map<String, dynamic>>> queryTodos(bool isCompleted) async {
    final db = await _dbService.database;
    return await db.query(
      "todos",
      where: 'is_completed = ?',
      whereArgs: [isCompleted ? 1 : 0],
      orderBy: 'date ASC',
    );
  }

  Future<int> updateTodoStatus(int id, bool isCompleted) async {
    final db = await _dbService.database;
    return await db.update(
      'todos',
      {'is_completed': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTodo(int id) async {
    final db = await _dbService.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
