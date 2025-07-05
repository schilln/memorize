import 'dart:collection';

import 'package:result_dart/result_dart.dart';

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

  Result<Memo> getMemo(int id) {
    try {
      Memo? result = _memos[id];
      return result == null ? Failure(Exception()) : Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Result<void> createMemo({required String name, required String content}) {
    try {
      final memo = Memo(id: _sequentialId++, name: name, content: content);
      _memos[memo.id] = memo;
      return Success.unit();
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Result<void> deleteMemo(int id) {
    try {
      _memos.remove(id);
      return Success.unit();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
