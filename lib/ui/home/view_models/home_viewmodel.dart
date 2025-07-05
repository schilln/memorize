import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:memorize/utils/exceptions/command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/memo_repository.dart';
import '../../../domain/models/memo/memo.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required MemoRepository memoRepository})
    : _memoRepository = memoRepository {
    load = Command.createSyncNoParam(
      _load,
      initialValue: Failure(CommandNotExecutedException()),
    )..execute();
  }
  late final Command<void, Result<void>> load;

  Command<void, Result<void>> createMemoCommand({
    required String name,
    required String content,
  }) {
    return Command.createSyncNoParam(
      () => _createMemo(name: name, content: content),
      initialValue: Failure(CommandNotExecutedException()),
    );
  }

  late final Command<int, Result<void>> deleteMemo = Command.createSync(
    _deleteMemo,
    initialValue: Failure(CommandNotExecutedException()),
  );
  int _counter = 0;

  final MemoRepository _memoRepository;
  List<Memo> _memos = [];
  UnmodifiableListView<Memo> get memos => UnmodifiableListView(_memos);

  Result<void> _load() {
    try {
      final result = _memoRepository.getMemos();
      return result.fold((success) {
        _memos = success;
        return Success.unit();
      }, (e) => Failure(e));
    } finally {
      notifyListeners();
    }
  }

  Result<void> _createMemo({required String name, required String content}) {
    try {
      return _memoRepository.createMemo(
        name: '$name $_counter',
        content: content,
      );
    } finally {
      notifyListeners();
      _counter++;
    }
  }

  Result<void> _deleteMemo(int id) {
    try {
      return _memoRepository.deleteMemo(id);
    } finally {
      notifyListeners();
    }
  }
}
