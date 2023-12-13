import 'package:bloc_test/bloc_test.dart';
import 'package:boh_tourbuch/models/product_order.dart';
import 'package:boh_tourbuch/repository/product_order_repository.dart';
import 'package:boh_tourbuch/widgets/edit_order_dialog/bloc/edit_order_dialog_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<ProductOrderRepository>()])
import 'edit_order_dialog_bloc_test.mocks.dart';

final o = ProductOrder(
    personId: -1,
    productTypeId: -2,
    status: OrderStatus.ordered,
    lastIssueDate: DateTime.now());
final someDate = DateTime.parse('2011-10-05T14:48:00.000Z');

void main() {
  late MockProductOrderRepository repo;
  late EditOrderDialogBloc bloc;
  late EditOrderDialogState editState;

  setUp(() {
    repo = MockProductOrderRepository();
    bloc = EditOrderDialogBloc(repo);
    editState = EditOrderDialogState(
        status: EditOrderDialogStatus.editing,
        productOrder: o,
        date: o.lastIssueDate,
        orderStatus: o.status);
  });

  group('test events', () {
    blocTest<EditOrderDialogBloc, EditOrderDialogState>('setOrder',
        build: () => bloc,
        act: (bloc) => bloc.add(EditOrderDialogEvent.setOrder(o)),
        expect: () => [
              EditOrderDialogState(
                  status: EditOrderDialogStatus.editing,
                  orderStatus: OrderStatus.ordered,
                  productOrder: o,
                  date: o.lastIssueDate)
            ]);

    blocTest<EditOrderDialogBloc, EditOrderDialogState>(
        'updateOrderStatus null',
        build: () => bloc,
        seed: () => editState,
        act: (bloc) =>
            bloc.add(const EditOrderDialogEvent.updateOrderStatus(null)),
        expect: () => <EditOrderDialogState>[]);

    blocTest<EditOrderDialogBloc, EditOrderDialogState>(
        'updateOrderStatus notOrdered',
        build: () => bloc,
        seed: () => editState,
        act: (bloc) => bloc.add(const EditOrderDialogEvent.updateOrderStatus(
            OrderStatus.notOrdered)),
        expect: () => [
              editState.copyWith(
                orderStatus: OrderStatus.notOrdered,
                date: null,
              )
            ]);

    blocTest<EditOrderDialogBloc, EditOrderDialogState>('updateDate null',
        build: () => bloc,
        seed: () => editState,
        act: (bloc) => bloc.add(const EditOrderDialogEvent.updateDate(null)),
        expect: () => [editState.copyWith(date: null)]);

    blocTest<EditOrderDialogBloc, EditOrderDialogState>('updateDate',
        build: () => bloc,
        seed: () => editState,
        act: (bloc) => bloc.add(EditOrderDialogEvent.updateDate(someDate)),
        expect: () => [editState.copyWith(date: someDate)]);
  });
}
