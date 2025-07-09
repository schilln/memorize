import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'config/dependencies.dart';
import 'routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Database db = await initializeDatabase();

  runApp(
    MultiProvider(
      providers: providersLocal(db: db),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: router(context.read()),
    );
  }
}

Future<Database> initializeDatabase() async {
  final String databasesPath = await getDatabasesPath();
  final String dbPath = p.join(databasesPath, 'app.db');

  // I could turn this into a command in MemoService and await it.
  return await openDatabase(
    dbPath,
    version: 1,
    onCreate: (final Database db, final int version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Memo (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT NOT NULL, 
          content TEXT NOT NULL, 
          keepFirstLetters INT, 
          fractionWordsKeep REAL
        )
      ''');
    },
  );
}

// Future<Database> initializeDatabase() async {
//   return await MemoService.open();
// }
