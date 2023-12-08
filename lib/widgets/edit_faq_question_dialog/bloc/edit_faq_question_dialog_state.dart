part of 'edit_faq_question_dialog_bloc.dart';

@immutable
abstract class EditFAQQuestionDialogState {}

class EditFAQQuestionDialogInitial extends EditFAQQuestionDialogState {
  final FAQQuestion? faqQuestion;
  final bool validate;

  EditFAQQuestionDialogInitial(this.faqQuestion, this.validate);
}

class ClosedDialog extends EditFAQQuestionDialogState {
  final bool saveClicked;

  ClosedDialog(this.saveClicked);
}
