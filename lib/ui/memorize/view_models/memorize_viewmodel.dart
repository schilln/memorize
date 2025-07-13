import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/memo_repository.dart';
import '../../../domain/models/memo/memo.dart';
import '../../../utils/exceptions/command.dart';

class MemorizeViewModel extends ChangeNotifier {
  MemorizeViewModel({
    required final int id,
    required final MemoRepository memoRepository,
  }) : _id = id,
       _memoRepository = memoRepository;

  late final Command<void, Result<Memo>> load =
      Command.createAsyncNoParam<Result<Memo>>(() async {
        return await _memoRepository.getMemo(_id).map((final success) {
          _memo = success;
          return _memo;
        });
      }, initialValue: Failure(CommandNotExecutedException()))..execute();

  late final Command<void, Result<void>> saveMemorizeState =
      Command.createAsyncNoParam<Result<void>>(() async {
        return await _memoRepository.updateMemo(
          id: _memo.id,
          keepFirstLetters: keepFirstLetters,
          fractionWordsKeep: fractionWordsKeep,
        );
      }, initialValue: Failure(CommandNotExecutedException()));

  String get name => _memo.name;

  String get content {
    final List<String> result = List.from(_contentList);

    final List<int> indicesToChange = _shuffledIdx.sublist(
      (_shuffledIdx.length * _fractionWordsKeepNotifier.value).floor(),
    );
    if (keepFirstLetters) {
      for (final int idx in indicesToChange) {
        final String s = result[idx];
        result[idx] = (RegExp(r'^\w+$').hasMatch(s))
            ? s[0] + '_' * (s.length - 1)
            : s;
      }
    } else {
      for (final int idx in indicesToChange) {
        final String s = result[idx];
        result[idx] = (RegExp(r'^\w+$').hasMatch(s)) ? '_' * s.length : s;
      }
    }

    return result.join('');
  }

  ValueListenable<bool> get keepFirstLettersListenable =>
      _keepFirstLettersNotifier as ValueListenable<bool>;

  ValueListenable<double> get fractionWordsKeepListenable =>
      _fractionWordsKeepNotifier as ValueListenable<double>;

  bool get keepFirstLetters => _keepFirstLettersNotifier.value;
  set keepFirstLetters(final bool value) {
    if (_keepFirstLettersNotifier.value != value) {
      _keepFirstLettersNotifier.value = value;
    }
  }

  double get fractionWordsKeep => _fractionWordsKeepNotifier.value;
  set fractionWordsKeep(final double value) {
    if (_fractionWordsKeepNotifier.value != value && 0 <= value && value <= 1) {
      _fractionWordsKeepNotifier.value = value;
    }
  }

  late final ValueNotifier<bool> _keepFirstLettersNotifier = ValueNotifier(
    _memo.keepFirstLetters ?? false,
  );

  late final ValueNotifier<double> _fractionWordsKeepNotifier = ValueNotifier(
    _memo.fractionWordsKeep ?? 0,
  );

  final int _id;
  final MemoRepository _memoRepository;
  late final Memo _memo;

  late final List<String> _contentList = RegExp(r'\w+|[^\w\s]|\s+')
      .allMatches(_memo.content)
      .map((final RegExpMatch match) => match.group(0) ?? '')
      .toList();

  late final List<int> _shuffledIdx = () {
    final rng = Random();
    final indices = List.generate(
      _contentList.length,
      (final int index) => index,
    );
    indices.shuffle(rng);
    return indices;
  }();
}
