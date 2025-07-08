import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../domain/models/memo/memo.dart';

class MemorizeViewModel extends ChangeNotifier {
  MemorizeViewModel({required final Memo memo}) : _memo = memo;

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

  ValueListenable<double> get fractionWordsKeepListenable =>
      _fractionWordsKeepNotifier as ValueListenable<double>;
  ValueListenable<bool> get keepFirstLettersListenable =>
      _keepFirstLettersNotifier as ValueListenable<bool>;

  double get fractionWordsKeep => _fractionWordsKeepNotifier.value;
  set fractionWordsKeep(final double value) {
    if (_fractionWordsKeepNotifier.value != value && 0 <= value && value <= 1) {
      _fractionWordsKeepNotifier.value = value;
    }
  }

  bool get keepFirstLetters => _keepFirstLettersNotifier.value;
  set keepFirstLetters(final bool value) {
    if (_keepFirstLettersNotifier.value != value) {
      _keepFirstLettersNotifier.value = value;
    }
  }

  final ValueNotifier<bool> _keepFirstLettersNotifier = ValueNotifier(false);
  final ValueNotifier<double> _fractionWordsKeepNotifier = ValueNotifier(0);

  final Memo _memo;

  late final List<String> _contentList = RegExp(r'\w+|[^\w\s]|\s+')
      .allMatches(_memo.content)
      .map((final RegExpMatch match) => match.group(0) ?? '')
      .toList();

  late final List<int> _shuffledIdx = () {
    final rng = Random(42);
    final indices = List.generate(
      _contentList.length,
      (final int index) => index,
    );
    indices.shuffle(rng);
    return indices;
  }();
}
