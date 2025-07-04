import 'package:result_dart/result_dart.dart';

import '../../domain/models/memo/memo.dart';

class MemoRepository {
  MemoRepository();

  final _memos = List<Memo>.empty(growable: true);
  int _sequentialId = 0;

  Result<List<Memo>> getMemos() {
    try {
      return Success(_memos);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Result<Memo> getMemo(int id) {
    try {
      return Success(_memos[id]);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Result<void> createMemo(Memo memo) {
    try {
      final memoWithId = memo.copyWith(id: _sequentialId++);
      _memos.add(memoWithId);
      return Success.unit();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
