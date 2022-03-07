import 'package:cubitsqlitecrud/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _db;

  DatabaseProvider._init();

// return a database instance
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _useDatabase('notes.db');
    return _db!;
  }

  Future<Database> _useDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
// Uncomment the two lines below to always delete the database
    // let the application start

    // String path = join(dbPath, 'notes.db');
    // wait deleteDatabase(path);

    // Returns the open database
    return await openDatabase(
      join(dbPath, 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, title2 TEXT, content TEXT)');
      },
      version: 1,
    );
  }

// fetch notes
  Future<List<Note>> fetchNotes() async {
    final db = await instance.db;
    final result = await db.rawQuery('SELECT * FROM notes ORDER BY id');
     print(result.length);
    // return result.map((json) => Note.fromJson(json)).toList();
    return result.map((json) => Note.fromMap(json)).toList();
  }

// create new note
  Future<Note> save(Note note) async {
    final db = await instance.db;
    final id = await db.rawInsert(
        'INSERT INTO notes (title, title2, content) VALUES (?,?,?)',
        [note.title, note.title2, note.content]);

// print('Note id $id created successfully.');
    return note.copyWith(id: id);
  }

// update grade
  Future<Note> update(Note note) async {
    final db = await instance.db;
    await db.rawUpdate('UPDATE notes SET title = ?, title2 = ?, content = ? WHERE id = ?',
        [note.title, note.title2, note.content, note.id]);

// print('Note id ${note.id} updated successfully.');
    return note;
  }

//delete all notes
  Future<int> deleteAll() async {
    final db = await instance.db;
    final result = await db.rawDelete('DELETE FROM notes');
// the result is the number of lines deleted
    // print('${result} successfully deleted notes.');
    return result;
  }

//delete single note
  Future<int> delete(int noteId) async {
    final db = await instance.db;
    final result =
        await db.rawDelete('DELETE FROM notes WHERE id = ?', [noteId]);
// print('Note id ${noteId} successfully deleted.');
    // the result is the number of lines deleted
    return result;
  }

//close connection to database, function not used in this app
  Future close() async {
    final db = await instance.db;
    db.close();
  }
}
