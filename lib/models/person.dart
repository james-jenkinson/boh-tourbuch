import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';

@freezed
class Person with _$Person {
  const factory Person({
      @Default(-1) int id,
      required String name,
      @Default(null) DateTime? blockedSince,
      @Default('') String comment
  }) = _Person;
}
