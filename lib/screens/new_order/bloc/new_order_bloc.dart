import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/person.dart';

part 'new_order_event.dart';
part 'new_order_state.dart';

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {

  late final Person _selectedPerson;

  NewOrderBloc() : super(NewOrderInitialState()) {
    on<NewOrderEvent>((event, emit) async {
      if (event is NewOrderInitialEvent) {
        _selectedPerson = event.selectedPerson;
        emit(NewOrderPersonLoaded(_selectedPerson));
      }
    });
  }
}
