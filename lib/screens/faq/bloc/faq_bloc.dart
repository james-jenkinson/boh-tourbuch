import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'faq_event.dart';
part 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  FaqBloc() : super(FaqInitial()) {
    on<FaqEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
