import 'package:bloc_test/bloc_test.dart';
import 'package:boh_tourbuch/models/comment.dart';
import 'package:boh_tourbuch/models/person.dart';
import 'package:boh_tourbuch/models/product_order.dart';
import 'package:boh_tourbuch/models/product_type.dart';
import 'package:boh_tourbuch/repository/comment_repository.dart';
import 'package:boh_tourbuch/repository/person_repository.dart';
import 'package:boh_tourbuch/repository/product_order_repository.dart';
import 'package:boh_tourbuch/repository/product_type_repository.dart';
import 'package:boh_tourbuch/screens/person/bloc/person_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<ProductTypeRepository>(),
  MockSpec<ProductOrderRepository>(),
  MockSpec<PersonRepository>(),
  MockSpec<CommentRepository>()
])
import 'person_bloc_test.mocks.dart';

void main() {
  late PersonBloc bloc;
  late MockProductTypeRepository productTypeRepository;
  late MockProductOrderRepository productOrderRepository;
  late MockPersonRepository personRepository;
  late MockCommentRepository commentRepository;

  final DateTime now = DateTime.now();

  late List<ProductType> productTypes;
  const Person person = Person(id: 1, name: 'p1');
  late List<ProductOrder> orders;
  final List<Comment> comments = [
    Comment(id: 1, personId: 1, issuedDate: now, content: 'Text'),
  ];

  late List<ProductOrderWithSymbol> productsWithSymbol;

  late PersonState initialState;

  setUp(() {
    productOrderRepository = MockProductOrderRepository();
    personRepository = MockPersonRepository();
    productTypeRepository = MockProductTypeRepository();
    commentRepository = MockCommentRepository();

    bloc = PersonBloc(personRepository, commentRepository,
        productTypeRepository, productOrderRepository, person);

    productTypes = [
      const ProductType(
          id: 1,
          name: 'p1',
          symbol: 'x',
          image: null,
          daysBlocked: 1,
          deletable: false),
      const ProductType(
          id: 2,
          name: 'p2',
          symbol: 'y',
          image: null,
          daysBlocked: 2,
          deletable: false),
      const ProductType(
          id: 3,
          name: 'p3',
          symbol: 'z',
          image: null,
          daysBlocked: 3,
          deletable: false),
    ];
    orders = [
      ProductOrder(
          id: 1,
          personId: 1,
          productTypeId: 1,
          status: OrderStatus.ordered,
          lastIssueDate: now.subtract(const Duration(days: 50))),
      const ProductOrder(
        id: -1,
        personId: 1,
        productTypeId: 2,
        status: OrderStatus.notOrdered,
      ),
      ProductOrder(
          id: 3,
          personId: 1,
          productTypeId: 3,
          status: OrderStatus.received,
          lastReceivedDate: now,
          lastIssueDate: now.subtract(const Duration(minutes: 1))),
    ];

    productsWithSymbol = [
      ProductOrderWithSymbol(
          id: 1,
          personId: 1,
          lastIssueDate: now.subtract(const Duration(days: 50)),
          lastReceivedDate: null,
          status: OrderStatus.ordered,
          productTypeId: 1,
          name: 'p1',
          symbol: 'x',
          image: null,
          blockedPeriod: 1),
      const ProductOrderWithSymbol(
          id: -1,
          personId: 1,
          lastIssueDate: null,
          lastReceivedDate: null,
          status: OrderStatus.notOrdered,
          productTypeId: 2,
          name: 'p2',
          symbol: 'y',
          image: null,
          blockedPeriod: 2),
      ProductOrderWithSymbol(
          id: 3,
          personId: 1,
          lastIssueDate: now.subtract(const Duration(minutes: 1)),
          lastReceivedDate: now,
          status: OrderStatus.received,
          productTypeId: 3,
          name: 'p3',
          symbol: 'z',
          image: null,
          blockedPeriod: 3),
    ];

    when(productTypeRepository.getProductTypes())
        .thenAnswer((_) => Future.value(productTypes));
    when(commentRepository.getCommentsByPersonId(1))
        .thenAnswer((_) => Future.value(comments));
    when(productOrderRepository.getProductOrdersByPersonId(1))
        .thenAnswer((_) => Future.value(orders));
    when(personRepository.getPersonById(1))
        .thenAnswer((_) => Future.value(person));

    initialState = PersonState(
        status: PersonScreenState.data,
        selectedPerson: person,
        productOrdersWithSymbols: productsWithSymbol,
        comments: comments);
  });

  group('Test events', () {
    blocTest<PersonBloc, PersonState>('initial',
        build: () => bloc,
        act: (bloc) => bloc.add(const PersonEvent.initial()),
        wait: const Duration(milliseconds: 100),
        expect: () => [initialState]);

    blocTest<PersonBloc, PersonState>('editedPerson ok',
        build: () => bloc,
        seed: () => initialState,
        act: (bloc) => bloc.add(const PersonEvent.editedPerson(true)),
        verify: (_) => verify(personRepository.getPersonById(1)).called(1),
        wait: const Duration(milliseconds: 100),
        expect: () => <PersonState>[]);

    blocTest<PersonBloc, PersonState>('editedPerson cancel',
        build: () => bloc,
        seed: () => initialState,
        act: (bloc) => bloc.add(const PersonEvent.editedPerson(false)),
        wait: const Duration(milliseconds: 100),
        expect: () => <PersonState>[]);

    blocTest<PersonBloc, PersonState>('orderClicked ordered',
        build: () {
          when(productTypeRepository.getProductTypes())
              .thenAnswer((_) => Future.value([productTypes[0]]));
          when(productOrderRepository.getProductOrdersByPersonId(1))
              .thenAnswer((_) => Future.value([orders[0]]));
          return bloc;
        },
        seed: () => initialState,
        act: (bloc) => bloc.add(PersonEvent.orderClicked(orders[0], true)),
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verify(productOrderRepository.updateProductOrder(argThat(predicate(
              (p0) =>
                  p0 is ProductOrder &&
                  p0.status == OrderStatus.received &&
                  p0.lastIssueDate != null &&
                  p0.lastReceivedDate != null)))).called(1);
        });

    blocTest<PersonBloc, PersonState>('orderClicked notOrdered',
        build: () {
          when(productTypeRepository.getProductTypes())
              .thenAnswer((_) => Future.value([productTypes[1]]));
          when(productOrderRepository.getProductOrdersByPersonId(1))
              .thenAnswer((_) => Future.value([orders[1]]));
          return bloc;
        },
        seed: () => initialState,
        act: (bloc) => bloc.add(PersonEvent.orderClicked(orders[1], true)),
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verify(productOrderRepository.createProductOrder(argThat(predicate(
              (p0) =>
                  p0 is ProductOrder &&
                  p0.status == OrderStatus.ordered &&
                  p0.lastIssueDate != null &&
                  p0.lastReceivedDate == null)))).called(1);
        });

    blocTest<PersonBloc, PersonState>('orderClicked received',
        build: () {
          when(productTypeRepository.getProductTypes())
              .thenAnswer((_) => Future.value([productTypes[2]]));
          when(productOrderRepository.getProductOrdersByPersonId(1))
              .thenAnswer((_) => Future.value([orders[2]]));
          return bloc;
        },
        // seed: () => initialState,
        act: (bloc) => bloc.add(PersonEvent.orderClicked(orders[2], true)),
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verify(productOrderRepository.updateProductOrder(argThat(predicate(
              (p0) =>
                  p0 is ProductOrder &&
                  p0.status == OrderStatus.ordered &&
                  p0.lastIssueDate!.isAfter(orders[2].lastIssueDate!) &&
                  p0.lastReceivedDate != null)))).called(1);
        });

    blocTest<PersonBloc, PersonState>('orderClicked click not allowed',
        build: () {
          when(productTypeRepository.getProductTypes())
              .thenAnswer((_) => Future.value([productTypes[2]]));
          when(productOrderRepository.getProductOrdersByPersonId(1))
              .thenAnswer((_) => Future.value([orders[2]]));
          return bloc;
        },
        seed: () => initialState,
        act: (bloc) => bloc.add(PersonEvent.orderClicked(orders[2], false)),
        wait: const Duration(milliseconds: 100),
        expect: () => <PersonState>[]);

    blocTest<PersonBloc, PersonState>('commentEdited new comment',
        build: () {
          return bloc;
        },
        seed: () => initialState,
        act: (bloc) => bloc.add(const PersonEvent.commentEdited('text', null)),
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verify(commentRepository.createComment(any)).called(1);
          verifyNever(commentRepository.updateComment(any));
        },
        expect: () => <PersonState>[]);

    blocTest<PersonBloc, PersonState>('commentEdited update comment',
        build: () {
          when(commentRepository.getCommentById(1)).thenAnswer((_) =>
              Future.value(Comment(
                  id: 1, personId: 1, issuedDate: now, content: 'oldText')));
          return bloc;
        },
        seed: () => initialState,
        act: (bloc) => bloc.add(const PersonEvent.commentEdited('text', 1)),
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verifyNever(commentRepository.createComment(any));
          verify(commentRepository.getCommentById(1)).called(1);
          verify(commentRepository.updateComment(any)).called(1);
        },
        expect: () => <PersonState>[]);

    blocTest<PersonBloc, PersonState>('commentStatusChanged',
        build: () {
          return bloc;
        },
        seed: () => initialState,
        act: (bloc) => bloc.add(PersonEvent.commentStatusChanged(
            Comment(personId: 1, issuedDate: now, id: 2), true)),
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verify(commentRepository.updateComment(Comment(
                  personId: 1, issuedDate: now, id: 2, commentDone: true)))
              .called(1);
        },
        expect: () => <PersonState>[]);

    blocTest<PersonBloc, PersonState>('resetOrder should not reset',
        build: () {
          return bloc;
        },
        seed: () => initialState,
        act: (bloc) => bloc.add(PersonEvent.resetOrder(orders[0], false)),
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verifyNever(productOrderRepository.delete(any));
        },
        expect: () => <PersonState>[]);

    blocTest<PersonBloc, PersonState>('resetOrder should reset',
        build: () {
          return bloc;
        },
        seed: () => initialState,
        act: (bloc) => bloc.add(PersonEvent.resetOrder(orders[0], true)),
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verify(productOrderRepository.delete(orders[0])).called(1);
        },
        expect: () => <PersonState>[]);

    blocTest<PersonBloc, PersonState>('deletePerson should delete',
        build: () {
          return bloc;
        },
        seed: () => initialState,
        act: (bloc) => bloc.add(const PersonEvent.deletePerson(true)),
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verify(personRepository.deletePerson(person.id)).called(1);
        },
        expect: () =>
            [initialState.copyWith(status: PersonScreenState.navigateHome)]);

    blocTest<PersonBloc, PersonState>('deletePerson should not delete',
        build: () {
          return bloc;
        },
        act: (bloc) => bloc.add(const PersonEvent.deletePerson(false)),
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verifyNever(personRepository.deletePerson(person.id));
        });
  });
}
