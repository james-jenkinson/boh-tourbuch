import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      if (event is OrdersButtonClickEvent) {
        emit(HomeNavigateOrders());
      } else if (event is FaqButtonClickEvent) {
        emit(HomeNavigateFaq());
      } else if (event is CommentsButtonClickEvent) {
        emit(HomeNavigateComments());
      }
    });
  }
}
