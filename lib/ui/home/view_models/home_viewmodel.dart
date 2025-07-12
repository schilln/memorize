import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/memo_repository.dart';
import '../../../domain/models/memo/memo.dart';
import '../../../utils/exceptions/command.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required final MemoRepository memoRepository})
    : _memoRepository = memoRepository;

  UnmodifiableListView<Memo> get memos => UnmodifiableListView(
    _memos.toList()..sort((final a, final b) => a.id.compareTo(b.id)),
  );

  late final Command<void, Result<void>> load =
      Command.createAsyncNoParam<Result<void>>(
        _load,
        initialValue: Failure(CommandNotExecutedException()),
      )..execute();

  late final UndoableCommand<int, Result<void>, Memo> deleteMemo =
      Command.createUndoable<int, Result<void>, Memo>(
            (final int id, final UndoStack<Memo> undoStack) async =>
                _deleteMemo(id: id, undoStack: undoStack),
            initialValue: Failure(CommandNotExecutedException()),
            undo: (final UndoStack<Memo> undoStack, final reason) async {
              final memo = undoStack.pop();
              return _undoDeleteMemo(memo: memo);
            },
            undoOnExecutionFailure: false,
          )
          as UndoableCommand<int, Result<void>, Memo>;

  final MemoRepository _memoRepository;
  List<Memo> _memos = [];

  Future<Result<void>> _load() async {
    final result = await _memoRepository.getMemos();
    return result.fold((final success) {
      _memos = success;
      return Success.unit();
    }, (final e) => Failure(e));
  }

  Future<Result<void>> _deleteMemo({
    required final int id,
    required final UndoStack<Memo> undoStack,
  }) async {
    try {
      final memo = _memoRepository.deleteMemo(id: id);
      return await memo.fold((final success) {
        undoStack.push(success);
        return Success.unit();
      }, (final e) => Failure(e));
    } finally {
      load.execute();
    }
  }

  Future<Result<int>> _undoDeleteMemo({required final Memo memo}) async {
    try {
      final newId = await _memoRepository.createMemo(memo: memo);
      return newId;
    } finally {
      load.execute();
    }
  }
}
