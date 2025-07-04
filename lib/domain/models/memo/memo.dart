import 'package:freezed_annotation/freezed_annotation.dart';

part 'memo.freezed.dart';

@freezed
abstract class Memo with _$Memo {
  factory Memo({int? id, required String name, required String content}) =
      _Memo;
}
