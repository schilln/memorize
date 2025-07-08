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

  Result<void> updateMemo({
    required final int id,
    required final String name,
    required final String content,
  }) {
    try {
      final Memo? memo = _memos[id];
      if (memo != null) {
        _memos[memo.id] = memo.copyWith(id: id, name: name, content: content);
        return Success(memo.id);
      } else {
        return Failure(KeyNotFoundException());
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Result<void> updateMemoMemorizeState({
    required final int id,
    final bool? keepFirstLetters,
    final double? fractionWordsKeep,
  }) {
    try {
      final Memo? memo = _memos[id];
      if (memo != null) {
        _memos[id] = memo.copyWith(
          keepFirstLetters: keepFirstLetters,
          fractionWordsKeep: fractionWordsKeep,
        );
        return Success.unit();
      } else {
        return Failure(KeyNotFoundException());
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
