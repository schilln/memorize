import 'package:flutter/widgets.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/memo_repository.dart';
import '../../../domain/models/memo/memo.dart';
import '../../../utils/exceptions/base.dart';
import '../../../utils/exceptions/command.dart';

class EditorViewModel extends ChangeNotifier {
  EditorViewModel({final int? id, required final MemoRepository memoRepository})
    : _id = id,
      _memoRepository = memoRepository;

  TextEditingController get nameController => _nameController;
  TextEditingController get contentController => _contentController;

  final MemoRepository _memoRepository;

  final _nameController = TextEditingController();
  final _contentController = TextEditingController();
  int? _id;

  late final CommandAsync<int, Result<void>> load =
      Command.createAsync<int, Result<void>>((final int id) async {
            try {
              final result = _memoRepository.getMemo(id);
              return result.fold((final success) {
                _id = success.id;
                _nameController.text = success.name;
                _contentController.text = success.content;
                return Success.unit();
              }, (final e) => Failure(e));
            } on Exception catch (e) {
              return Failure(e);
            }
          }, initialValue: Failure(CommandNotExecutedException()))
          as CommandAsync<int, Result<void>>;

  late final CommandAsync<void, Result<void>> save =
      Command.createAsyncNoParam<Result<void>>(() async {
            final name = nameController.text;
            final content = contentController.text;

            if (name.trim().isEmpty || content.trim().isEmpty) {
              return Failure(
                SimpleMessageException('Name and content must not be empty.'),
              );
            }

            if (_id != null) {
              return _updateMemo(id: _id!, name: name, content: content);
            } else {
              return _createMemo(name: name, content: content);
            }
          }, initialValue: Failure(CommandNotExecutedException()))
          as CommandAsync<void, Result<void>>;

  Future<Result<int>> _createMemo({
    required final String name,
    required final String content,
  }) async {
    try {
      final id = await _memoRepository.createMemo(
        memo: NewMemo(name: name, content: content),
      );
      return id;
    } finally {
      // TODO: Is this needed?
      notifyListeners();
    }
  }

  Future<Result<void>> _updateMemo({
    required final int id,
    required final String name,
    required final String content,
  }) async {
    try {
      final result = await _memoRepository.updateMemo(
        id: id,
        name: name,
        content: content,
      );
      return result;
    } finally {
      // TODO: Is this needed?
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
