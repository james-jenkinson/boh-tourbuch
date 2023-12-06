part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class OpenSettingsDialog extends HomeState {}

class NavigateToSettings extends HomeState {}

class WrongPassword extends HomeState {}

class NavigateToFAQ extends HomeState {}
