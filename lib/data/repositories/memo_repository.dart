import 'dart:collection';

import 'package:result_dart/result_dart.dart';

import '../../../utils/exceptions/base.dart';
import '../../domain/models/memo/memo.dart';

class MemoRepository {
  MemoRepository();

  final Map<int, Memo> _memos = {};
  int _sequentialId = 0;

  Result<UnmodifiableListView<Memo>> getMemos() {
    try {
      final result = UnmodifiableListView(_memos.values);
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Result<Memo> getMemo(final int id) {
    try {
      final Memo? result = _memos[id];
      return result == null ? Failure(Exception()) : Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Result<int> createMemo({
    final int? id,
    required final String name,
    required final String content,
  }) {
    try {
      late final Memo memo;
      if (id != null && !_memos.containsKey(id)) {
        memo = Memo(id: id, name: name, content: content);
      } else {
        memo = Memo(id: _sequentialId++, name: name, content: content);
      }
      _memos[memo.id] = memo;
      return Success(memo.id);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Result<Memo> deleteMemo(final int id) {
    try {
      final memo = _memos.remove(id);
      return memo != null ? Success(memo) : Failure(KeyNotFoundException());
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Result<int> updateMemo({
    required final int id,
    required final String name,
    required final String content,
  }) {
    try {
      if (_memos.containsKey(id)) {
        final memo = Memo(id: id, name: name, content: content);
        _memos[memo.id] = memo;
        return Success(memo.id);
      } else {
        return Failure(KeyNotFoundException());
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
