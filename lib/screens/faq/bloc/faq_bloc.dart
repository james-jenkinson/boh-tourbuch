import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/faq_question.dart';
import '../../../repository/faq_question_repository.dart';

part 'faq_bloc.freezed.dart';

part 'faq_event.dart';

part 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  final FAQQuestionRepository _faqQuestionRepository = FAQQuestionRepository();

  FaqBloc() : super(const FaqState()) {
    on<FaqEvent>((event, emit) async {
      await event.when(loadData: () async {
        final List<FAQQuestion> faqQuestions =
            await _faqQuestionRepository.getAllFAQQuestion();
        emit(state.copyWith(
            status: FaqScreenStatus.data, faqQuestions: faqQuestions));
      });
    });
  }
}
