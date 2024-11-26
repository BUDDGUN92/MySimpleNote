import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

/// A helper class to manage the SQLite database for notes.
///
/// This class provides methods to initialize the database, create tables,
/// and perform CRUD operations on the notes table.
class DatabaseHelper {
  /// Singleton instance of [DatabaseHelper].
  static final DatabaseHelper instance = DatabaseHelper._init();

  /// Private constructor to initialize the singleton instance.
  DatabaseHelper._init();

  /// The SQLite database instance.
  static Database? _database;

  /// Getter to retrieve the database instance.
  ///
  /// If the database is not already initialized, it will be created and
  /// initialized with the specified file path.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  /// Initializes the database with the given file path.
  ///
  /// This method creates the database file and sets up the necessary tables.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Creates the notes table in the database.
  ///
  /// This method is called when the database is created for the first time.
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id TEXT PRIMARY KEY,
      description TEXT,
      completed INTEGER
    )
    ''');
  }

  /// Inserts a new note into the notes table.
  ///
  /// Returns the number of rows affected.
  Future<int> insertNote(Note note) async {
    final db = await instance.database;
    final data = {
      'id': note.id,
      'description': note.description,
      'completed': note.completed ? 1 : 0,
    };
    return await db.insert('notes', data);
  }

  /// Fetches all notes from the notes table.
  ///
  /// Returns a list of maps representing the notes.
  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final db = await instance.database;
    return await db.query('notes');
  }

  /// Fetches a note by its ID from the notes table.
  ///
  /// Returns a map representing the note, or null if not found.
  Future<Map<String, dynamic>?> getNoteById(String id) async {
    final db = await instance.database;
    final results = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Updates an existing note in the notes table.
  ///
  /// Returns the number of rows affected.
  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      {
        'description': note.description,
        'completed': note.completed ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  /// Deletes a note by its ID from the notes table.
  ///
  /// Returns the number of rows affected.
  Future<int> deleteNote(String id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Deletes all notes from the notes table.
  ///
  /// Returns the number of rows affected.
  Future<int> deleteAllNotes() async {
    final db = await instance.database;
    return await db.delete('notes');
  }

  /// Closes the database connection.
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
