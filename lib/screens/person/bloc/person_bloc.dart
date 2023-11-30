import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/comment.dart';
import '../../../models/person.dart';
import '../../../models/product_order.dart';
import '../../../models/product_type.dart';
import '../../../repository/comment_repository.dart';
import '../../../repository/person_repository.dart';
import '../../../repository/product_order_repository.dart';
import '../../../repository/product_type_repository.dart';

part 'person_event.dart';

part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository _personRepository = PersonRepository();
  final CommentRepository _commentRepository = CommentRepository();
  final ProductTypeRepository _productTypeRepository = ProductTypeRepository();
  final ProductOrderRepository _productOrderRepository =
      ProductOrderRepository();

  late Person _selectedPerson;

  PersonBloc() : super(PersonInitial()) {
    on<PersonEvent>((event, emit) async {
      if (event is PersonInitialEvent) {
        _selectedPerson = event.selectedPerson;
        emit(await fetchAndEmitPersonLoaded());
      } else if (event is PersonEditedEvent) {
        if (event.personEdited == true) {
          _selectedPerson = (await _personRepository
              .getPersonById(_selectedPerson.id))!; // person must be defined
          emit(await fetchAndEmitPersonLoaded());
        }
      } else if (event is CommentEditedEvent) {
        if (event.commentId == null && event.content != null) {
          await _commentRepository.createComment(Comment(
            personId: _selectedPerson.id,
            issuedDate: DateTime.now(),
            content: event.content!,
          ));
        } else if (event.commentId != null && event.content != null) {
          await _commentRepository.updateComment(Comment(
            id: event.commentId!,
            personId: _selectedPerson.id,
            issuedDate: DateTime.now(),
            content: event.content!,
          ));
        }
        emit(await fetchAndEmitPersonLoaded());
      } else if (event is ProductOrderClickedEvent) {
        if (event.clickAllowed) {
          final editCopy = event.productOrder;
          switch (editCopy.status) {
            case OrderStatus.notOrdered:
            case OrderStatus.received:
              {
                editCopy.status = OrderStatus.ordered;
                editCopy.lastIssueDate = DateTime.now();
              }
            case OrderStatus.ordered:
              {
                editCopy.status = OrderStatus.received;
                editCopy.lastReceivedDate = DateTime.now();
              }
          }
          if (editCopy.id == -1) {
            await _productOrderRepository.createProductOrder(editCopy);
          } else {
            await _productOrderRepository.updateProductOrder(editCopy);
          }
          emit(await fetchAndEmitPersonLoaded());
        }
      } else if (event is CommentStatusChangedEvent) {
        final editCopy = event.comment;
        editCopy.commentDone = event.newValue;
        await _commentRepository.updateComment(editCopy);
        emit(await fetchAndEmitPersonLoaded());
      }
    });
  }

  Future<PersonLoaded> fetchAndEmitPersonLoaded() async {
    final List<ProductType> productTypes =
        await _productTypeRepository.getProductTypes();
    final List<Comment> comments =
        await _commentRepository.getCommentsByPersonId(_selectedPerson.id);
    final productOrders = await _productOrderRepository
        .getProductOrdersByPersonId(_selectedPerson.id);
    final List<ProductOrderWithSymbol> productOrdersWithSymbols = [];

    for (final type in productTypes) {
      final productOrder = productOrders.firstWhere(
          (order) => order.productTypeId == type.id,
          orElse: () => ProductOrder(
              personId: _selectedPerson.id,
              productTypeId: type.id,
              status: OrderStatus.notOrdered));
      productOrdersWithSymbols.add(ProductOrderWithSymbol(
          id: productOrder.id,
          name: type.name,
          symbol: type.symbol,
          blockedPeriod: type.daysBlocked,
          personId: productOrder.personId,
          productTypeId: productOrder.productTypeId,
          lastIssueDate: productOrder.lastIssueDate,
          status: productOrder.status,
          lastReceivedDate: productOrder.lastReceivedDate));
    }
    return PersonLoaded(_selectedPerson, productOrdersWithSymbols, comments);
  }
}

class ProductOrderWithSymbol extends ProductOrder {
  String name;
  String symbol;
  int blockedPeriod;

  ProductOrderWithSymbol(
      {required this.name,
      required this.symbol,
      required this.blockedPeriod,
      required super.personId,
      required super.productTypeId,
      required super.lastIssueDate,
      required super.lastReceivedDate,
      required super.status,
      super.id});
}
