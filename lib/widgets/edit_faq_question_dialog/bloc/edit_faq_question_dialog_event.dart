part of 'edit_faq_question_dialog_bloc.dart';

@immutable
abstract class EditFAQQuestionDialogEvent {}

class FormChangedEvent extends EditFAQQuestionDialogEvent{
  final bool? validate;
  FormChangedEvent(this.validate);
}

class SaveClickedEvent extends EditFAQQuestionDialogEvent {
  SaveClickedEvent();
}

class CancelClickedEvent extends EditFAQQuestionDialogEvent {
  CancelClickedEvent();
}
