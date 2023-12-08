import 'package:freezed_annotation/freezed_annotation.dart';

part 'faq_question.freezed.dart';

@freezed
class FAQQuestion with _$FAQQuestion {
  const factory FAQQuestion({
    @Default(-1) int id,
    required String question,
    required String answer,
  }) = _FAQQuestion;
}
