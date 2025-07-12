import 'package:freezed_annotation/freezed_annotation.dart';

part 'memo.freezed.dart';
part 'memo.g.dart';

sealed class BaseMemo {
  const BaseMemo({
    required this.name,
    required this.content,
    this.keepFirstLetters,
    this.fractionWordsKeep,
  });

  final String name;
  final String content;
  final bool? keepFirstLetters;
  final double? fractionWordsKeep;

  Map<String, dynamic> toJson();
}

@freezed
abstract class NewMemo extends BaseMemo with _$NewMemo {
  const NewMemo._({
    required super.name,
    required super.content,
    super.keepFirstLetters,
    super.fractionWordsKeep,
  });

  const factory NewMemo({
    required final String name,
    required final String content,
    final bool? keepFirstLetters,
    final double? fractionWordsKeep,
  }) = _NewMemo;

  factory NewMemo.fromJson(final Map<String, dynamic> json) =>
      _$NewMemoFromJson(json);

  Memo fromNewMemo({required final int id}) {
    return Memo(id: id, name: name, content: content);
  }
}

@freezed
abstract class Memo extends BaseMemo with _$Memo {
  const Memo._({
    required super.name,
    required super.content,
    super.keepFirstLetters,
    super.fractionWordsKeep,
  });

  const factory Memo({
    required final int id,
    required final String name,
    required final String content,
    final bool? keepFirstLetters,
    final double? fractionWordsKeep,
  }) = _Memo;

  factory Memo.fromJson(final Map<String, dynamic> json) =>
      _$MemoFromJson(json);
}
