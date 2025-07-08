import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/memo_repository.dart';
import '../../../domain/models/memo/memo.dart';
import '../../../utils/exceptions/command.dart';
import '../../../utils/stack_collection.dart';

typedef CommandFuture<TParam, TResult, TUndoState> = ({
  UndoableCommand<TParam, TResult, TUndoState> command,
  Future<TResult> future,
});

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required final MemoRepository memoRepository})
    : _memoRepository = memoRepository;

  late final Command<void, Result<void>> load =
      Command.createSyncNoParam<Result<void>>(
        _load,
        initialValue: Failure(CommandNotExecutedException()),
      )..execute();

  final MemoRepository _memoRepository;
  List<Memo> _memos = [];
  UnmodifiableListView<Memo> get memos => UnmodifiableListView(
    _memos.toList()..sort((final a, final b) => a.id.compareTo(b.id)),
  );

  final StackCollection<CommandFuture<void, Result<void>, Memo>>
  _deleteCommandFutureStack = StackCollection();

  Result<void> _load() {
    try {
      final result = _memoRepository.getMemos();
      return result.fold((final success) {
        _memos = success;
        return Success.unit();
      }, (final e) => Failure(e));
    } finally {
      notifyListeners();
    }
  }

  void undoDelete() async {
    final (:command, :future) = _deleteCommandFutureStack.pop();
    await future;
    command.undo();
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
      notifyListeners();
    }
  }

  Result<void> deleteMemo({required final int id}) {
    final command = _makeDeleteMemoCommand(id: id);
    final future = command.executeWithFuture();
    _deleteCommandFutureStack.push((command: command, future: future));
    return command.value;
  }

  UndoableCommand<void, Result<void>, Memo> _makeDeleteMemoCommand({
    required final int id,
  }) {
    return Command.createUndoableNoParam<Result<void>, Memo>(
          (final UndoStack<Memo> undoStack) async =>
              _deleteMemo(undoStack: undoStack, id: id),
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
        as UndoableCommand<void, Result<void>, Memo>;
  }

  Result<void> _deleteMemo({
    final UndoStack<Memo>? undoStack,
    required final int id,
  }) {
    try {
      final memo = _memoRepository.deleteMemo(id);
      return memo.fold((final success) {
        undoStack?.push(success);
        return Success.unit();
      }, (final e) => Failure(e));
    } finally {
      notifyListeners();
    }
  }
}
