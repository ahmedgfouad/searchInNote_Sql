import 'dart:developer';

import 'package:search_note_sql/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static const String _databaseName= 'note.db';
  static const int _databaseVersion= 1;
  static const String _tableName= 'notes';
  static const String _columnId= 'id';
  static const String _columnTitle= 'title';
  static const String _columnNote= 'note';

  DatabaseHelper._internal();
  static final  DatabaseHelper instance =DatabaseHelper._internal();
  static Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final String path = '$dbPath/$_databaseName';
    log(path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  _onCreate (Database db , int version) async{
    db.execute('''
    CREATE TABLE $_tableName( 
     $_columnId INTEGER PRIMARY KEY ,
    $_columnTitle TEXT NOT NULL ,
    $_columnNote TEXT NOT NULL  
    )
    ''');
  }

  Future<List<NoteModel>> getAllData() async{
    Database db =await instance._database;
    List<Map<String , dynamic>> response =await db.query(
        _tableName,
        columns:[
      _columnId,
      _columnTitle,
      _columnNote,
    ]);
    return response.map((e) => NoteModel.fromMap(e)).toList();
}

  Future<int> insertToDatabase(NoteModel noteModel)async{
    Database db = await instance._database;
    return await db.insert(_tableName, noteModel.toMap());
  }

  Future<int> deleteFromDatabase(int id) async {
    Database db = await instance._database;
    return await db
        .delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<List<NoteModel>>searchNotes(String text) async{
    Database db=await instance._database;
   final response =await db.query(_tableName,columns: [
      _columnId,
      _columnTitle,
      _columnNote,
    ],
    where: '$_columnTitle LIKE ?',
      whereArgs: ['%$text%']
    );return response.map((e) => NoteModel.fromMap(e)).toList();
  }

}