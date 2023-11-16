import 'package:boh_tourbuch/models/order.dart';
import 'package:boh_tourbuch/repository/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'comments_event.dart';

part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final OrderRepository _orderRepository = OrderRepository();

  bool _selectedStatusOpen = true;

  CommentsBloc() : super(CommentsInitialState()) {
    on<CommentsEvent>((event, emit) async {
      if (event is SelectStatusEvent) {
        selectNewStatus(event.selectedIndex);
        emit(await createCommentsLoadedState());
      }
    });
  }

  /// index 0 = open
  /// index 1 = closed
  void selectNewStatus(int selectedIndex) {
    _selectedStatusOpen = selectedIndex == 0;
  }

  Future<CommentsLoadedState> createCommentsLoadedState() async {
    return CommentsLoadedState(
        await _orderRepository.getAllOrdersWithComment(_selectedStatusOpen), [
      _selectedStatusOpen,
      !_selectedStatusOpen,
    ]);
  }
}
