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
  late Command<void, Result<void>> load;

  late final Command<({String name, String content}), Result<void>> createMemo =
      Command.createSync(
        _createMemo,
        initialValue: Failure(CommandNotExecutedException()),
      );

  late final Command<int, Result<void>> deleteMemo = Command.createSync(
    _deleteMemo,
    initialValue: Failure(CommandNotExecutedException()),
  );

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

  Result<void> _createMemo(({String name, String content}) params) {
    try {
      return _memoRepository.createMemo(
        name: params.name,
        content: params.content,
      );
    } finally {
      notifyListeners();
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
