import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/memo_repository.dart';
import '../../../domain/models/memo/memo.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required MemoRepository memoRepository})
    : _memoRepository = memoRepository {
    load = Command.createSyncNoParam(_load, initialValue: Success.unit())
      ..execute();
    createMemo = Command.createSyncNoParam(
      _createMemo,
      initialValue: Success.unit(),
    );
  }
  late Command<void, Result<void>> load;
  late Command<void, Result<void>> createMemo;

  final MemoRepository _memoRepository;
  List<Memo> _memos = [];
  List<Memo> get memos => _memos;

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

  Result<void> _createMemo() {
    try {
      return _memoRepository.createMemo(Memo(name: 'Name', content: 'Content'));
    } finally {
      notifyListeners();
    }
  }
}
