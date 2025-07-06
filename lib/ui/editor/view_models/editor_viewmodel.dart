import 'package:flutter/widgets.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/memo_repository.dart';
import '../../../utils/exceptions/command.dart';

class EditorViewmodel extends ChangeNotifier {
  EditorViewmodel({required MemoRepository memoRepository})
    : _memoRepository = memoRepository;

  TextEditingController get nameController => _nameController;
  TextEditingController get contentController => _contentController;

  final MemoRepository _memoRepository;
  final _nameController = TextEditingController();
  final _contentController = TextEditingController();

  Future<Result<int>> save() async {
    final name = nameController.text;
    final content = contentController.text;
    final command = _makeCreateMemoCommand(name: name, content: content);
    await command.executeWithFuture();
    return command.value;
  }

  Command<void, Result<int>> _makeCreateMemoCommand({
    required String name,
    required String content,
  }) {
    return Command.createAsyncNoParam(
      () async => _createMemo(name: name, content: content),
      initialValue: Failure(CommandNotExecutedException()),
    );
  }

  Result<int> _createMemo({required String name, required String content}) {
    try {
      final id = _memoRepository.createMemo(name: name, content: content);
      return id;
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
