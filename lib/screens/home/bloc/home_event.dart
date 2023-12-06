part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class OpenSettingsDialogEvent extends HomeEvent {
  OpenSettingsDialogEvent();
}

class DialogCompletedEvent extends HomeEvent {
  final bool login;
  DialogCompletedEvent(this.login);
}

class CloseDialogEvent extends HomeEvent {
  CloseDialogEvent();
}

class OpenFAQEvent extends HomeEvent {
  OpenFAQEvent();
}