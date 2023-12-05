import 'package:bloc_test/bloc_test.dart';
import 'package:boh_tourbuch/models/person.dart';
import 'package:boh_tourbuch/models/product_order.dart';
import 'package:boh_tourbuch/models/product_type.dart';
import 'package:boh_tourbuch/repository/person_repository.dart';
import 'package:boh_tourbuch/repository/product_order_repository.dart';
import 'package:boh_tourbuch/repository/product_type_repository.dart';
import 'package:boh_tourbuch/screens/orders/bloc/model/order_table_row.dart';
import 'package:boh_tourbuch/screens/orders/bloc/model/product_type_with_selection.dart';
import 'package:boh_tourbuch/screens/orders/bloc/orders_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<ProductTypeRepository>(),
  MockSpec<PersonRepository>(),
  MockSpec<ProductOrderRepository>()
])
import 'orders_bloc_test.mocks.dart';

void main() {
  late OrdersBloc bloc;
  late MockProductTypeRepository productTypeRepository;
  late MockPersonRepository personRepository;
  late MockProductOrderRepository productOrderRepository;

  final DateTime now = DateTime.now();

  final List<ProductType> productTypes = [
    ProductType(
        id: 1, name: 'p1', symbol: 'x', daysBlocked: 1, deletable: true),
    ProductType(
        id: 2, name: 'p2', symbol: 'y', daysBlocked: 2, deletable: false),
  ];
  final List<Person> persons = [
    const Person(id: 1, name: 'p1'),
    const Person(id: 2, name: 'p2'),
  ];
  final List<ProductOrder> orders = [
    ProductOrder(
        id: 1,
        personId: 1,
        productTypeId: 1,
        status: OrderStatus.ordered,
        lastIssueDate: now),
    ProductOrder(
        id: 2,
        personId: 1,
        productTypeId: 2,
        status: OrderStatus.ordered,
        lastIssueDate: now),
    ProductOrder(
        id: 3,
        personId: 2,
        productTypeId: 1,
        status: OrderStatus.ordered,
        lastIssueDate: now),
    const ProductOrder(
        id: 4, personId: 2, productTypeId: 2, status: OrderStatus.notOrdered),
  ];

  late OrdersState initialState;

  setUp(() {
    productOrderRepository = MockProductOrderRepository();
    personRepository = MockPersonRepository();
    productTypeRepository = MockProductTypeRepository();

    bloc = OrdersBloc(
        productTypeRepository, personRepository, productOrderRepository);

    when(productTypeRepository.getProductTypes())
        .thenAnswer((_) => Future.value(productTypes));
    when(personRepository.getAllPersons())
        .thenAnswer((_) => Future.value(persons));

    when(productOrderRepository
            .getAllByStatusAndType(OrderStatus.ordered, [1, 2]))
        .thenAnswer((_) => Future.value([orders[0], orders[1], orders[2]]));
    when(productOrderRepository.getAllByStatusAndType(OrderStatus.ordered, [1]))
        .thenAnswer((_) => Future.value([orders[0], orders[2]]));

    initialState = OrdersState(
        status: OrdersScreenState.data,
        productTypes: [
          const ProductTypeWithSelection(
              productTypeId: 1, name: 'p1', symbol: 'x', amount: 2),
          const ProductTypeWithSelection(
              productTypeId: 2, name: 'p2', symbol: 'y', amount: 1),
        ],
        tableRows: [
          OrderTableRow(person: persons[0], productIdOrdered: {
            1: now,
            2: now,
          }),
          OrderTableRow(person: persons[1], productIdOrdered: {1: now})
        ],
        sortIndex: null,
        sortFieldId: -1,
        asc: true,
        person: null);
  });

  group('Test events', () {
    blocTest<OrdersBloc, OrdersState>('initial',
        build: () => bloc,
        act: (bloc) => bloc.add(const OrdersEvent.initial()),
        wait: const Duration(milliseconds: 100),
        expect: () => [initialState]);

    blocTest<OrdersBloc, OrdersState>('filterChanged',
        build: () => bloc,
        seed: () => initialState,
        act: (bloc) => bloc.add(const OrdersEvent.filterChanged(false, 2)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
              initialState.copyWith(
                productTypes: [
                  const ProductTypeWithSelection(
                      productTypeId: 1,
                      name: 'p1',
                      symbol: 'x',
                      amount: 2,
                      selected: true),
                  const ProductTypeWithSelection(
                      productTypeId: 2,
                      name: 'p2',
                      symbol: 'y',
                      amount: 1,
                      selected: false),
                ],
                tableRows: [
                  OrderTableRow(person: persons[0], productIdOrdered: {
                    1: now,
                  }),
                  OrderTableRow(person: persons[1], productIdOrdered: {
                    1: now,
                  })
                ],
              )
            ]);

    blocTest<OrdersBloc, OrdersState>('filterChanged set correct sort index',
        build: () => bloc,
        seed: () => initialState.copyWith(sortFieldId: 2, sortIndex: 2),
        act: (bloc) => bloc.add(const OrdersEvent.filterChanged(false, 1)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
              initialState.copyWith(
                sortIndex: 1,
                sortFieldId: 2,
                productTypes: [
                  const ProductTypeWithSelection(
                      productTypeId: 1,
                      name: 'p1',
                      symbol: 'x',
                      amount: 2,
                      selected: false),
                  const ProductTypeWithSelection(
                      productTypeId: 2,
                      name: 'p2',
                      symbol: 'y',
                      amount: 1,
                      selected: true),
                ],
                tableRows: [],
              )
            ]);

    blocTest<OrdersBloc, OrdersState>('filterChanged set sort index to null',
        build: () => bloc,
        seed: () => initialState.copyWith(sortFieldId: 2, sortIndex: 2),
        act: (bloc) => bloc.add(const OrdersEvent.filterChanged(false, 2)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
              initialState.copyWith(
                sortIndex: null,
                sortFieldId: 2,
                productTypes: [
                  const ProductTypeWithSelection(
                      productTypeId: 1,
                      name: 'p1',
                      symbol: 'x',
                      amount: 2,
                      selected: true),
                  const ProductTypeWithSelection(
                      productTypeId: 2,
                      name: 'p2',
                      symbol: 'y',
                      amount: 1,
                      selected: false),
                ],
                tableRows: [
                  OrderTableRow(person: persons[0], productIdOrdered: {
                    1: now,
                  }),
                  OrderTableRow(person: persons[1], productIdOrdered: {
                    1: now,
                  })
                ],
              )
            ]);

    blocTest<OrdersBloc, OrdersState>('sortChanged ASC',
        build: () => bloc,
        seed: () => initialState,
        act: (bloc) => bloc.add(const OrdersEvent.sortChanged(1, 1, true)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
              initialState.copyWith(tableRows: [
                OrderTableRow(person: persons[0], productIdOrdered: {
                  1: now,
                  2: now,
                }),
                OrderTableRow(person: persons[1], productIdOrdered: {1: now})
              ], sortIndex: 1, sortFieldId: 1)
            ]);

    blocTest<OrdersBloc, OrdersState>('sortChanged DESC',
        build: () => bloc,
        seed: () => initialState,
        act: (bloc) => bloc.add(const OrdersEvent.sortChanged(0, -1, false)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
              initialState.copyWith(tableRows: [
                OrderTableRow(person: persons[1], productIdOrdered: {1: now}),
                OrderTableRow(person: persons[0], productIdOrdered: {
                  1: now,
                  2: now,
                }),
              ], sortIndex: 0, sortFieldId: -1, asc: false)
            ]);

    blocTest<OrdersBloc, OrdersState>('navigate',
        build: () => bloc,
        seed: () => initialState,
        act: (bloc) =>
            bloc.add(const OrdersEvent.navigate(Person(id: 1, name: 'p1'))),
        wait: const Duration(milliseconds: 100),
        expect: () => [
              initialState.copyWith(
                  status: OrdersScreenState.navigateToPerson,
                  person: const Person(id: 1, name: 'p1'))
            ]);

    blocTest<OrdersBloc, OrdersState>('returnFromNavigation',
        build: () => bloc,
        seed: () => initialState.copyWith(
            status: OrdersScreenState.navigateToPerson,
            person: const Person(id: 1, name: 'p1')),
        act: (bloc) => bloc.add(const OrdersEvent.returnFromNavigation()),
        wait: const Duration(milliseconds: 100),
        expect: () => [initialState.copyWith()]);
  });
}
