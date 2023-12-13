import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  TextEditingController password = TextEditingController();
  final String _adminPassword =
      const String.fromEnvironment('ADMIN_PASSWORD', defaultValue: 'boh');

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      if (event is OpenSettingsDialogEvent) {
        emit(OpenSettingsDialog());
      } else if (event is DialogCompletedEvent) {
        if (event.login) {
          if (password.value.text == _adminPassword) {
            password.text = '';
            emit(NavigateToSettings());
          } else {
            emit(WrongPassword());
          }
        }
      } else if (event is OpenFAQEvent) {
        emit(NavigateToFAQ());
      }
    });
  }
}
