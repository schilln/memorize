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
  HomeViewModel({required MemoRepository memoRepository})
    : _memoRepository = memoRepository {
    load = Command.createSyncNoParam<Result<void>>(
      _load,
      initialValue: Failure(CommandNotExecutedException()),
    )..execute();
  }
  late final Command<void, Result<void>> load;

  final MemoRepository _memoRepository;
  List<Memo> _memos = [];
  UnmodifiableListView<Memo> get memos => UnmodifiableListView(
    _memos.toList()..sort((a, b) => a.id.compareTo(b.id)),
  );

  final StackCollection<CommandFuture<void, Result<void>, Memo>>
  _deleteCommandFutureStack = StackCollection();

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

  void undoDelete() async {
    var (:command, :future) = _deleteCommandFutureStack.pop();
    await future;
    command.undo();
  }

  Result<int> _createMemo({
    int? id,
    required String name,
    required String content,
  }) {
    try {
      var newId = _memoRepository.createMemo(
        id: id,
        name: name,
        content: content,
      );
      return newId;
    } finally {
      notifyListeners();
    }
  }

  Result<void> deleteMemo({required int id}) {
    var command = _makeDeleteMemoCommand(id: id);
    var future = command.executeWithFuture();
    _deleteCommandFutureStack.push((command: command, future: future));
    return command.value;
  }

  UndoableCommand<void, Result<void>, Memo> _makeDeleteMemoCommand({
    required int id,
  }) {
    return Command.createUndoableNoParam<Result<void>, Memo>(
          (UndoStack<Memo> undoStack) async =>
              _deleteMemo(undoStack: undoStack, id: id),
          initialValue: Failure(CommandNotExecutedException()),
          undo: (UndoStack<Memo> undoStack, reason) async {
            var memo = undoStack.pop();
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

  Result<void> _deleteMemo({UndoStack<Memo>? undoStack, required int id}) {
    try {
      var memo = _memoRepository.deleteMemo(id);
      return memo.fold((success) {
        undoStack?.push(success);
        return Success.unit();
      }, (e) => Failure(e));
    } finally {
      notifyListeners();
    }
  }
}
