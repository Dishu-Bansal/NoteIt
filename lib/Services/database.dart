import 'dart:async';
import 'dart:core';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:sqflite/sqlite_api.dart';
import 'package:test_2/shared/Note.dart';
import 'package:test_2/shared/todo.dart';

Database _database;
Future<Database> get createDatabase async {
  //if (_database != null) {
  //  return _database;
  // }

  _database = await initDB();
  return _database;
}

initDB() async {
  var path = await getDatabasesPath();
  var dbpath = join(path, 'data2.db');
  print(dbpath);
  Database dbconnection = await openDatabase(dbpath, version: 2,
      onCreate: (Database db, int version) async {
    await db.execute(_buildCreatetodosQuery());
    await db.execute(_buildCreatenotesQuery());
  });

  return dbconnection;
}

String _buildCreatenotesQuery() {
  String query =
      "CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title BLOB, content BLOB, date_created INTEGER, date_updated INTEGER)";
  return query;
}

String _buildCreatetodosQuery() {
  String query =
      "CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY AUTOINCREMENT, done BLOB, task BLOB, date_updated INTEGER)";
  return query;
}

updateToDo(Todo task) async {
  final Database db = await createDatabase;

  await db.update('todos', task.toMap(true),
      where: 'id = ?',
      whereArgs: [task.id],
      conflictAlgorithm: ConflictAlgorithm.replace);
}

insertToDo(Todo task, bool isNew) async {
  final Database db = await createDatabase;

  await db.insert(
    'todos',
    isNew ? task.toMap(false) : task.toMap(true),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  return task.id;
}

insertNote(Note note, bool isNew) async {
  final Database db = await createDatabase;

  await db.insert(
    'notes',
    isNew ? note.toMap(false) : note.toMap(true),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  return note.id;
}

Future<bool> deletetodo(Todo task) async {
  final Database db = await createDatabase;
  try {
    await db.delete('todos', where: 'id = ?', whereArgs: [task.id]);
    return true;
  } catch (Error) {
    print('Error deleting ToDo');
    return false;
  }
}

Future<bool> deleteNote(Note note) async {
  final Database db = await createDatabase;
  try {
    await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);
    return true;
  } catch (Error) {
    print('Error deleting note');
    return false;
  }
}

Future<List<Map<String, dynamic>>> seletAlltodos() async {
  final Database db = await createDatabase;

  var data = await db.query('todos', orderBy: 'date_updated desc');

  return data;
}

Future<List<Map<String, dynamic>>> seletAllNotes() async {
  final Database db = await createDatabase;

  var data = await db.query('notes', orderBy: 'date_updated desc');

  return data;
}
