import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/models/todo_model.dart';

class TodoLocalDataSource {
  Database? _database;

  // This getter ensures we only open the database once
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    // Find the path on the phone to store the database
    String path = join(await getDatabasesPath(), 'todo_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the table when the app runs for the first time
        await db.execute('''
          CREATE TABLE "todos" (
            "id" INTEGER PRIMARY KEY AUTOINCREMENT,
            "title" TEXT,
            "description" TEXT,
            "isCompleted" INTEGER
          )
        ''');
      },
    );
  }

  // CREATE
  Future<void> insertTodo(TodoModel todo) async {
    final db = await database;
    await db.insert('todos', todo.toJson());
  }

  // READ
  Future<List<TodoModel>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return maps.map((json) => TodoModel.fromJson(json)).toList();
  }

  // UPDATE
  Future<void> updateTodo(TodoModel todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toJson(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // DELETE
  Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
