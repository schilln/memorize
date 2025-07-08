import 'package:freezed_annotation/freezed_annotation.dart';

part 'memo.freezed.dart';

@freezed
abstract class Memo with _$Memo {
  factory Memo({
    required final int id,
    required final String name,
    required final String content,
    final bool? keepFirstLetters,
    final double? fractionWordsKeep,
  }) = _Memo;
}
