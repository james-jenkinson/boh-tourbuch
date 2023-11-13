import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../models/person.dart';

part 'new_order_event.dart';
part 'new_order_state.dart';

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {

  late final Person _selectedPerson;

  NewOrderBloc() : super(NewOrderInitialState()) {
    on<NewOrderEvent>((event, emit) async {
      if (event is NewOrderInitialEvent) {
        print('Reacting to initial event ${event.selectedPerson.firstName}');
        _selectedPerson = event.selectedPerson;
        print('All set ${_selectedPerson.firstName}');
        emit(NewOrderPersonLoaded(_selectedPerson));
      }
    });
  }
}
