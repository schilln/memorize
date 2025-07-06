import 'package:flutter/widgets.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/memo_repository.dart';
import '../../../domain/models/memo/memo.dart';
import '../../../utils/exceptions/command.dart';

class EditorViewmodel extends ChangeNotifier {
  EditorViewmodel({required final MemoRepository memoRepository})
    : _memoRepository = memoRepository;

  TextEditingController get nameController => _nameController;
  TextEditingController get contentController => _contentController;

  final MemoRepository _memoRepository;

  final _nameController = TextEditingController();
  final _contentController = TextEditingController();
  int? _idIfUpdate;

  Future<Result<void>> load({required final int id}) async {
    final command = _makeLoadCommand(id: id);
    final result = await command.executeWithFuture();
    result.fold((final success) {
      _idIfUpdate = success.id;
      _nameController.text = success.name;
      _contentController.text = success.content;
    }, (final e) => Failure(e));
    return command.value;
  }

  CommandAsync<void, Result<Memo>> _makeLoadCommand({required final int id}) {
    return Command.createAsyncNoParam<Result<Memo>>(
          () => _load(id: id),
          initialValue: Failure(CommandNotExecutedException()),
        )
        as CommandAsync<void, Result<Memo>>;
  }

  Future<Result<Memo>> _load({required final int id}) async {
    try {
      final result = _memoRepository.getMemo(id);
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> save() async {
    final name = nameController.text;
    final content = contentController.text;
    late final CommandAsync<void, Result<void>> command;
    if (_idIfUpdate == null) {
      command = _makeCreateMemoCommand(name: name, content: content);
    } else {
      command = _makeUpdateMemoCommand(
        id: _idIfUpdate!,
        name: name,
        content: content,
      );
    }
    await command.executeWithFuture();
    return command.value;
  }

  CommandAsync<void, Result<int>> _makeCreateMemoCommand({
    required final String name,
    required final String content,
  }) {
    return Command.createAsyncNoParam<Result<int>>(
          () async => _createMemo(name: name, content: content),
          initialValue: Failure(CommandNotExecutedException()),
        )
        as CommandAsync<void, Result<int>>;
  }

  Result<int> _createMemo({
    required final String name,
    required final String content,
  }) {
    try {
      final id = _memoRepository.createMemo(name: name, content: content);
      return id;
    } finally {
      notifyListeners();
    }
  }

  CommandAsync<void, Result<void>> _makeUpdateMemoCommand({
    required final int id,
    required final String name,
    required final String content,
  }) {
    return Command.createAsyncNoParam<Result<void>>(
          () async => _updateMemo(id: id, name: name, content: content),
          initialValue: Failure(CommandNotExecutedException()),
        )
        as CommandAsync<void, Result<void>>;
  }

  Result<void> _updateMemo({
    required final int id,
    required final String name,
    required final String content,
  }) {
    try {
      final result = _memoRepository.updateMemo(
        id: id,
        name: name,
        content: content,
      );
      return result;
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    contentController.dispose();
    super.dispose();
  }
}
