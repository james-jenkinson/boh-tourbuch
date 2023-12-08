part of 'faq_bloc.dart';

enum FaqScreenStatus { initial, data }


@freezed
class FaqState with _$FaqState {
  const factory FaqState({
    @Default(FaqScreenStatus.initial) FaqScreenStatus status,
    @Default([]) List<FAQQuestion> faqQuestions
}) = _FaqState;
}
