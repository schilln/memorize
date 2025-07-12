import 'package:sqflite/sqflite.dart';

final String _table = 'Memo';

class MemoService {
  MemoService({required final DatabaseFactory databaseFactory})
    : _databaseFactory = databaseFactory;

  final DatabaseFactory _databaseFactory;
  Database? _database;

  void deleteMe() {
    _databaseFactory;
    _database;
    _table;
  }
}
