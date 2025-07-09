import 'package:flutter_command/flutter_command.dart';
import 'package:path/path.dart' as p;
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/exceptions/command.dart';

class MemoService {
  MemoService({required final Database db}) : _db = db;

  late final CommandAsync<void, Result<void>> open =
      Command.createAsyncNoParam<Result<void>>(() async {
            final String databasesPath = await getDatabasesPath();
            final String dbPath = p.join(databasesPath, 'app.db');
            _db = await openDatabase(dbPath);
            return Success.unit();
          }, initialValue: Failure(CommandNotExecutedException()))
          as CommandAsync<void, Result<void>>;

  late final Database _db;

  Future<Result<int>> createMemo({
    required final String name,
    required final String content,
    final bool? keepFirstLetters,
    final double? fractionWordsKeep,
  }) async {
    try {
      final int result = await _db.transaction((final txn) async {
        return await txn.rawInsert(
          '''
            INSERT INTO Memo(name, content, keepFirstLetters, fractionWordsKeep)
            VALUES(?, ?, ?, ?)
          ''',
          [name, content, keepFirstLetters, fractionWordsKeep],
        );
      });
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<Map<String, Object?>>>> getMemo({
    required final int id,
  }) async {
    try {
      final List<Map<String, Object?>> result = await _db.transaction((
        final txn,
      ) async {
        return await txn.rawQuery('SELECT * FROM Memo WHERE id = ?', [id]);
      });
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<Map<String, Object?>>>> getMemos() async {
    try {
      final List<Map<String, Object?>> result = await _db.transaction((
        final txn,
      ) async {
        return await txn.rawQuery('SELECT * FROM Memo');
      });
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<int>> updateMemo({
    required final String name,
    required final String content,
    final bool? keepFirstLetters,
    final double? fractionWordsKeep,
  }) async {
    try {
      final int result = await _db.transaction((final txn) async {
        return await txn.rawUpdate(
          '''
            INSERT INTO Memo(name, content, keepFirstLetters, fractionWordsKeep)
            VALUES(?, ?, ?, ?)
          ''',
          [name, content, keepFirstLetters, fractionWordsKeep],
        );
      });
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<int>> deleteMemo({required final int id}) async {
    try {
      final int result = await _db.transaction((final txn) async {
        return await txn.rawDelete('DELETE FROM Memo WHERE id = ?', [id]);
      });
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
