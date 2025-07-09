import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';

import '../data/repositories/memo_repository.dart';
import '../data/services/memo_service.dart';

List<SingleChildWidget> providersLocal({required final Database db}) {
  return [
    Provider<Database>.value(value: db),
    Provider(create: (final context) => MemoService(db: context.read())),
    Provider(
      create: (final context) => MemoRepository(memoService: context.read()),
    ),
  ];
}
