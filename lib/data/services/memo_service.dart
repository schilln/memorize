import 'package:path/path.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/models/memo/memo.dart';

final String _tableMemo = 'Memo';
final String _colId = 'id';
final String _colName = 'name';
final String _colContent = 'content';
final String _colKeepFirstLetters = 'keepFirstLetters';
final String _colFractionWordsKeep = 'fractionWordsKeep';
final List<String> _memoCols = [
  _colId,
  _colName,
  _colContent,
  _colKeepFirstLetters,
  _colFractionWordsKeep,
];

class MemoService {
  MemoService({required final DatabaseFactory dbFactory})
    : _dbFactory = dbFactory;

  bool isOpen() => _db != null;

  final DatabaseFactory _dbFactory;
  Database? _db;

  Future<Result<void>> _open() async {
    final String path = join(
      await _dbFactory.getDatabasesPath(),
      'app_database.db',
    );
    try {
      _db = await _dbFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (final Database db, final int version) async {
            await db.execute('''
            CREATE TABLE IF NOT EXISTS $_tableMemo(
              $_colId INTEGER PRIMARY KEY AUTOINCREMENT, 
              $_colName TEXT NOT NULL, 
              $_colContent TEXT NOT NULL, 
              $_colKeepFirstLetters INT, 
              $_colFractionWordsKeep REAL
            )''');
          },
        ),
      );
      return Success.unit();
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<int>> createMemo({required final BaseMemo memo}) async {
    try {
      if (!isOpen()) {
        final Exception? e = (await _open()).exceptionOrNull();
        if (e != null) {
          return Failure(e);
        }
      }
      final int result = await _db!.transaction((final txn) async {
        return await txn.insert(_tableMemo, memo.toJson());
      });
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Map<int, Memo>>> getMemos() async {
    try {
      if (!isOpen()) {
        final Exception? e = (await _open()).exceptionOrNull();
        if (e != null) {
          return Failure(e);
        }
      }
      final List<Map<String, Object?>> maps = await _db!.transaction((
        final txn,
      ) async {
        return await txn.query(_tableMemo, columns: _memoCols);
      });
      final Map<int, Memo> memos = {};
      for (final map in maps) {
        final memo = Memo.fromJson(map);
        memos[memo.id] = memo;
      }

      return Success(memos);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Memo>> getMemo({required final int id}) async {
    try {
      if (!isOpen()) {
        final Exception? e = (await _open()).exceptionOrNull();
        if (e != null) {
          return Failure(e);
        }
      }
      final Map<String, Object?> result = (await _db!.transaction((
        final txn,
      ) async {
        return await txn.query(
          _tableMemo,
          columns: _memoCols,
          where: '$_colId = ?',
          whereArgs: [id],
        );
      })).first;
      return Success(Memo.fromJson(result));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<int>> updateMemo({required final Memo memo}) async {
    try {
      if (!isOpen()) {
        final Exception? e = (await _open()).exceptionOrNull();
        if (e != null) {
          return Failure(e);
        }
      }
      final int result = await _db!.transaction((final txn) async {
        return await txn.update(_tableMemo, memo.toJson());
      });
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<int>> deleteMemo({required final int id}) async {
    try {
      if (!isOpen()) {
        final Exception? e = (await _open()).exceptionOrNull();
        if (e != null) {
          return Failure(e);
        }
      }
      final int result = await _db!.transaction((final txn) async {
        return await txn.delete(
          _tableMemo,
          where: '$_colId = ?',
          whereArgs: [id],
        );
      });
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
