import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/comment.dart';
import '../../../models/person.dart';
import '../../../models/product_order.dart';
import '../../../models/product_type.dart';
import '../../../repository/comment_repository.dart';
import '../../../repository/person_repository.dart';
import '../../../repository/product_order_repository.dart';
import '../../../repository/product_type_repository.dart';

part 'person_bloc.freezed.dart';

part 'person_event.dart';

part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository _personRepository;
  final CommentRepository _commentRepository;
  final ProductTypeRepository _productTypeRepository;
  final ProductOrderRepository _productOrderRepository;

  PersonBloc(
      this._personRepository,
      this._commentRepository,
      this._productTypeRepository,
      this._productOrderRepository,
      Person selectedPerson)
      : super(PersonState(selectedPerson: selectedPerson)) {
    on<PersonEvent>((event, emit) async {
      await event.when(
        initial: () async {
          emit(await fetchAndEmitPersonLoaded(state));
        },
        editedPerson: (bool? personEdited) async {
          if (personEdited == true) {
            emit(await fetchAndEmitPersonLoaded(
              state.copyWith(
                  selectedPerson: (await _personRepository
                      .getPersonById(state.selectedPerson.id))!),
            ));
          }
        },
        orderClicked: (ProductOrder productOrder, bool clickAllowed) async {
          if (clickAllowed) {
            final o = productOrder;
            final editCopy = isNotOrdered(o) || isReceived(o)
                ? o.copyWith(
              status: OrderStatus.ordered,
              lastIssueDate: DateTime.now(),
            )
                : o.copyWith(
              status: OrderStatus.received,
              lastReceivedDate: DateTime.now(),
            );

            if (editCopy.id == -1) {
              await _productOrderRepository.createProductOrder(editCopy);
            } else {
              await _productOrderRepository.updateProductOrder(editCopy);
            }
            emit(await fetchAndEmitPersonLoaded(state));
          }
        },
        commentEdited: (String? content, int? commentId) async {
          if (commentId == null && content != null) {
            await _commentRepository.createComment(Comment(
              personId: state.selectedPerson.id,
              issuedDate: DateTime.now(),
              content: content,
            ));
          } else if (commentId != null && content != null) {
            await _commentRepository.updateComment(Comment(
              id: commentId,
              personId: state.selectedPerson.id,
              issuedDate: DateTime.now(),
              content: content,
            ));
          }
          emit(await fetchAndEmitPersonLoaded(state));
        },
        commentStatusChanged: (Comment comment, bool newValue) async {
          final editCopy = comment.copyWith(commentDone: newValue);
          await _commentRepository.updateComment(editCopy);
          emit(await fetchAndEmitPersonLoaded(state));
        },
        resetOrder: (ProductOrder productOrder, bool? shouldReset) async {
          if (shouldReset == true) {
            await _productOrderRepository.delete(productOrder);
            emit(await fetchAndEmitPersonLoaded(state));
          }
        },
        deletePerson: (bool? shouldDelete) async {
          if (shouldDelete == true) {
            await _personRepository.deletePerson(state.selectedPerson.id);
            emit(state.copyWith(status: PersonScreenState.navigateHome));
          }
        },
      );
    });
  }

  Future<PersonState> fetchAndEmitPersonLoaded(PersonState state) async {
    final List<ProductType> productTypes =
        await _productTypeRepository.getProductTypes();
    final List<Comment> comments =
        await _commentRepository.getCommentsByPersonId(state.selectedPerson.id);
    final productOrders = await _productOrderRepository
        .getProductOrdersByPersonId(state.selectedPerson.id);
    final List<ProductOrderWithSymbol> productOrdersWithSymbols = [];

    for (final type in productTypes) {
      final productOrder = productOrders.firstWhere(
              (order) => order.productTypeId == type.id,
          orElse: () => ProductOrder(
              personId: state.selectedPerson.id,
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
    return state.copyWith(
        status: PersonScreenState.data,
        comments: comments,
        productOrdersWithSymbols: productOrdersWithSymbols);
  }
}
