import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String _tableMemo = 'Memo';
final String _colId = 'id';
final String _colName = 'name';
final String _colContent = 'content';
final String _colKeepFirstLetters = 'keepFirstLetters';
final String _colFractionWordsKeep = 'fractionWordsKeep';

class MemoService {
  MemoService({required final DatabaseFactory dbFactory})
    : _dbFactory = dbFactory;

  final DatabaseFactory _dbFactory;
  Database? _db;

  Future<void> _open() async {
    final String path = join(
      await _dbFactory.getDatabasesPath(),
      'app_database.db',
    );
    _db = await _dbFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (final Database db, final int version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $_tableMemo
              $_colId INTEGER PRIMARY KEY AUTOINCREMENT, 
              $_colName TEXT NOT NULL, 
              $_colContent TEXT NOT NULL, 
              $_colKeepFirstLetters INT, 
              $_colFractionWordsKeep REAL
            )''');
        },
      ),
    );
  }

  void deleteMe() {
    _open();
    _db;
  }
}
