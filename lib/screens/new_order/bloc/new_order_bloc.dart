import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/order.dart';
import '../../../models/person.dart';
import '../../../models/product.dart';
import '../../../models/product_type.dart';
import '../../../repository/order_repository.dart';
import '../../../repository/product_repository.dart';
import '../../../repository/product_type_repository.dart';
import '../../../until/date_time_ext.dart';

part 'new_order_event.dart';

part 'new_order_state.dart';

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {
  final _orderRepository = OrderRepository();
  final _productRepository = ProductRepository();
  final _productTypeRepository = ProductTypeRepository();
  late final Person _selectedPerson;

  // List of product types and a flag that indicates, whether the corresponding product is selected for this order
  late List<(ProductType, bool)> types;
  DateTime chosenDate = DateTime.now();

  TextEditingController textEditingControllerDate =
      TextEditingController.fromValue(
          TextEditingValue(text: DateTime.now().toCalendarDate()));
  TextEditingController textEditingControllerComment = TextEditingController();

  NewOrderBloc() : super(NewOrderInitialState()) {
    on<NewOrderEvent>((event, emit) async {
      if (event is NewOrderInitialEvent) {
        _selectedPerson = event.selectedPerson;
        types = (await _productTypeRepository.getProductTypes())
            .map((type) => (type, false))
            .toList();
        emit(NewOrderUpdatedState(types));
      } else if (event is NewOrderProductSelectionChangedEvent) {
        final index =
            types.indexWhere((type) => type.$1.id == event.productType.id);
        if (index > -1) {
          types[index] = (types[index].$1, !types[index].$2);
        }
        emit(NewOrderUpdatedState(types));
      } else if (event is NewOrderSaveEvent) {
        final int orderId = await _orderRepository.createOrder(Order(
            personId: _selectedPerson.id,
            createDate:
                DateTimeExt.fromCalenderDate(textEditingControllerDate.text),
            comment: textEditingControllerComment.text));
        final List<Product> products =
            types.where((type) => type.$2).map((type) {
          return Product(
            orderId: orderId,
            productTypeId: type.$1.id,
            status: ProductStatus.notOrdered,
          );
        }).toList();
        for (final product in products) {
          await _productRepository.createProduct(product);
        }
        emit(NewOrderSavedState());
      }
    });
  }

  @override
  Future<void> close() async {
    textEditingControllerDate.dispose();
    textEditingControllerComment.dispose();
    await super.close();
  }
}
