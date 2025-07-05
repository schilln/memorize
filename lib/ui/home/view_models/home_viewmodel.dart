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
    load = Command.createSyncNoParam(
      _load,
      initialValue: Failure(CommandNotExecutedException()),
    )..execute();
  }
  late final Command<void, Result<void>> load;

  final MemoRepository _memoRepository;
  List<Memo> _memos = [];
  UnmodifiableListView<Memo> get memos => UnmodifiableListView(_memos);

  final StackCollection<CommandFuture<void, Result<int>, int>>
  _commandFutureStack = StackCollection();

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

  void undoCreate() async {
    var (:command, :future) = _commandFutureStack.pop();
    await future;
    command.undo();
  }

  Result<int> createMemo({required String name, required String content}) {
    var command = _makeCreateMemoCommand(name: name, content: content);
    var future = command.executeWithFuture();
    _commandFutureStack.push((command: command, future: future));
    return command.value;
  }

  UndoableCommand<void, Result<int>, int> _makeCreateMemoCommand({
    required String name,
    required String content,
  }) {
    return Command.createUndoableNoParam<Result<int>, int>(
          (UndoStack<int> undoStack) async =>
              _createMemo(undoStack: undoStack, name: name, content: content),
          initialValue: Failure(CommandNotExecutedException()),
          undo: (UndoStack<int> undoStack, reason) async {
            var id = undoStack.pop();
            return _deleteMemo(id: id);
          },
          undoOnExecutionFailure: false,
        )
        as UndoableCommand<void, Result<int>, int>;
  }

  Result<int> _createMemo({
    required UndoStack<int> undoStack,
    required String name,
    required String content,
  }) {
    try {
      var id = _memoRepository.createMemo(name: name, content: content);
      return id.fold((success) {
        undoStack.push(success);
        return id;
      }, (e) => Failure(e));
    } finally {
      notifyListeners();
    }
  }

  Result<int> deleteMemo({required int id}) {
    var command = _makeDeleteMemoCommand(id: id)..execute();
    return command.value;
  }

  Command<void, Result<int>> _makeDeleteMemoCommand({required int id}) {
    return Command.createSyncNoParam(
      () => _deleteMemo(id: id),
      initialValue: Failure(CommandNotExecutedException()),
    );
  }

  Result<int> _deleteMemo({required int id}) {
    try {
      return _memoRepository.deleteMemo(id);
    } finally {
      notifyListeners();
    }
  }
}
