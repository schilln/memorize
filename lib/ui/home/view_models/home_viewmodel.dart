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
      Command.createSyncNoParam<Result<void>>(
        _load,
        initialValue: Failure(CommandNotExecutedException()),
      )..execute();

  late final UndoableCommand<int, Result<void>, Memo> deleteMemoCommand =
      Command.createUndoable<int, Result<void>, Memo>(
            (final int id, final UndoStack<Memo> undoStack) async =>
                _deleteMemo(id: id, undoStack: undoStack),
            initialValue: Failure(CommandNotExecutedException()),
            undo: (final UndoStack<Memo> undoStack, final reason) async {
              final memo = undoStack.pop();
              return _createMemo(
                id: memo.id,
                name: memo.name,
                content: memo.content,
              );
            },
            undoOnExecutionFailure: false,
          )
          as UndoableCommand<int, Result<void>, Memo>;

  final MemoRepository _memoRepository;
  List<Memo> _memos = [];

  Result<void> _load() {
    final result = _memoRepository.getMemos();
    return result.fold((final success) {
      _memos = success;
      return Success.unit();
    }, (final e) => Failure(e));
  }

  Result<void> _deleteMemo({
    required final int id,
    required final UndoStack<Memo> undoStack,
  }) {
    try {
      final memo = _memoRepository.deleteMemo(id);
      return memo.fold((final success) {
        undoStack.push(success);
        return Success.unit();
      }, (final e) => Failure(e));
    } finally {
      load.execute();
    }
  }

  Result<int> _createMemo({
    final int? id,
    required final String name,
    required final String content,
  }) {
    try {
      final newId = _memoRepository.createMemo(
        id: id,
        name: name,
        content: content,
      );
      return newId;
    } finally {
      load.execute();
    }
  }
}
