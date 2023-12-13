import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/faq_question.dart';
import '../../../repository/faq_question_repository.dart';

part 'edit_faq_question_dialog_event.dart';
part 'edit_faq_question_dialog_state.dart';

class EditFAQQuestionDialogBloc
    extends Bloc<EditFAQQuestionDialogEvent, EditFAQQuestionDialogState> {
  final FAQQuestion? faqQuestion;
  final TextEditingController question = TextEditingController();
  final TextEditingController answer = TextEditingController();
  final FAQQuestionRepository _faqQuestionRepository = FAQQuestionRepository();

  EditFAQQuestionDialogBloc(this.faqQuestion)
      : super(EditFAQQuestionDialogInitial(faqQuestion, faqQuestion != null)) {
    question.text = faqQuestion?.question ?? '';
    answer.text = faqQuestion?.answer ?? '';

    on<EditFAQQuestionDialogEvent>((event, emit) async {
      if (event is FormChangedEvent) {
        emit(EditFAQQuestionDialogInitial(
            faqQuestion, event.validate != null && event.validate == true));
      } else if (event is CancelClickedEvent) {
        emit(ClosedDialog(false));
      } else if (event is SaveClickedEvent) {
        if (faqQuestion == null) {
          await _faqQuestionRepository.createFAQQuestion(FAQQuestion(
            question: question.value.text,
            answer: answer.value.text,
          ));
        } else {
          await _faqQuestionRepository.updateFAQQuestion(faqQuestion!.copyWith(
            question: question.value.text,
            answer: answer.value.text,
          ));
        }
        emit(ClosedDialog(true));
      }
    });
  }

  @override
  Future<void> close() async {
    question.dispose();
    answer.dispose();
    await super.close();
  }
}
