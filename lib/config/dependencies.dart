import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';

import '../data/repositories/memo_repository.dart';
import '../data/services/memo_service.dart';

List<SingleChildWidget> providersLocal({
  required final DatabaseFactory databaseFactory,
}) {
  return [
    Provider<DatabaseFactory>.value(value: databaseFactory),
    Provider(create: (final context) => MemoService(dbFactory: context.read())),
    Provider(
      create: (final context) => MemoRepository(memoService: context.read()),
    ),
  ];
}
