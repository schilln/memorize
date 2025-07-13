import 'dart:collection';

import 'package:result_dart/result_dart.dart';

import '../../../utils/exceptions/base.dart';
import '../../domain/models/memo/memo.dart';
import '../services/memo_service.dart';

class MemoRepository {
  MemoRepository({required final MemoService memoService})
    : _memoService = memoService;

  final MemoService _memoService;

  final Map<int, Memo> _cachedMemos = {};
  bool _isLoaded = false;

  Future<Result<void>> refresh() async {
    try {
      final Result<Map<int, Memo>> result = await _memoService.getMemos();
      return result.map((final success) {
        _cachedMemos.clear();
        _cachedMemos.addAll(success);
        _isLoaded = true;
        return success;
      });
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<UnmodifiableListView<Memo>>> getMemos() async {
    try {
      if (!_isLoaded) {
        final refreshResult = (await refresh()).exceptionOrNull();
        if (refreshResult != null) {
          return Failure(refreshResult);
        }
      }
      final result = UnmodifiableListView(_cachedMemos.values);
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Memo>> getMemo(final int id) async {
    try {
      if (!_isLoaded) {
        final refreshResult = (await refresh()).exceptionOrNull();
        if (refreshResult != null) {
          return Failure(refreshResult);
        }
      }
      final result = _cachedMemos[id];
      return result == null ? Failure(Exception()) : Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<int>> createMemo({required final BaseMemo memo}) async {
    try {
      final Result<int> newId = await _memoService.createMemo(memo: memo);
      newId.fold((final success) {
        switch (memo) {
          case NewMemo():
            _cachedMemos[success] = memo.fromNewMemo(id: success);
          case Memo():
            _cachedMemos[success] = memo.copyWith(id: success);
        }
      }, (final e) => Failure(e));
      return newId;
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Memo>> deleteMemo({required final int id}) async {
    try {
      final result = await _memoService.deleteMemo(id: id);
      return result.flatMap((final success) {
        final memo = _cachedMemos.remove(id);
        return memo != null ? Success(memo) : Failure(KeyNotFoundException());
      });
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<void>> updateMemo({
    required final int id,
    final String? name,
    final String? content,
    final bool? keepFirstLetters,
    final double? fractionWordsKeep,
  }) async {
    try {
      final result = await _memoService.updateMemo(
        id: id,
        name: name,
        content: content,
        keepFirstLetters: keepFirstLetters,
        fractionWordsKeep: fractionWordsKeep,
      );
      return result.map((final success) async {
        final updated = await _memoService.getMemo(id: id);
        return updated.map((final success) {
          _cachedMemos[id] = success;
          return Success.unit();
        });
      });
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
