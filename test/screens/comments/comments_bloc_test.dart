import 'package:bloc_test/bloc_test.dart';
import 'package:boh_tourbuch/models/comment.dart';
import 'package:boh_tourbuch/models/person.dart';
import 'package:boh_tourbuch/repository/comment_repository.dart';
import 'package:boh_tourbuch/repository/person_repository.dart';
import 'package:boh_tourbuch/screens/comment/bloc/comment_bloc.dart';
import 'package:boh_tourbuch/screens/comment/model/comment_with_person.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<CommentRepository>(),
  MockSpec<PersonRepository>(),
])
import 'comments_bloc_test.mocks.dart';

void main() {
  late CommentBloc bloc;
  late MockCommentRepository commentRepository;
  late MockPersonRepository personRepository;

  final now = DateTime.now();
  final List<Person> persons = [
    const Person(id: 1, name: 'p1'),
    const Person(id: 2, name: 'p2'),
  ];
  final List<Comment> commentsDone = [
    Comment(
        id: 1,
        personId: 1,
        issuedDate: now.subtract(const Duration(minutes: 5)),
        content: 'Text',
        commentDone: true),
    Comment(
        id: 2,
        personId: 1,
        issuedDate: now.subtract(const Duration(minutes: 10)),
        commentDone: true),
    Comment(
        id: 3,
        personId: 1,
        issuedDate: now.subtract(const Duration(minutes: 57)),
        content: 'Zweiter Text',
        commentDone: true),
    Comment(
        id: 4,
        personId: 2,
        issuedDate: now.subtract(const Duration(minutes: 100)),
        commentDone: true),
    Comment(
        id: 5,
        personId: 2,
        issuedDate: now.subtract(const Duration(minutes: 1)),
        commentDone: true),
  ];

  late CommentState initialState;

  setUp(() {
    commentRepository = MockCommentRepository();
    personRepository = MockPersonRepository();

    bloc = CommentBloc(commentRepository, personRepository);

    initialState = const CommentState()
        .copyWith(status: CommentScreenState.data, commentsWithPerson: [
      CommentWithPerson(comment: commentsDone[0], person: persons[0]),
      CommentWithPerson(comment: commentsDone[1], person: persons[0]),
      CommentWithPerson(comment: commentsDone[2], person: persons[0]),
      CommentWithPerson(comment: commentsDone[3], person: persons[1]),
      CommentWithPerson(comment: commentsDone[4], person: persons[1]),
    ]);

    when(commentRepository.getAllCommentsByStatus(true))
        .thenAnswer((realInvocation) => Future.value(commentsDone));
    when(commentRepository.getAllCommentsByStatus(false))
        .thenAnswer((realInvocation) => Future.value([commentsDone[3]]));
    when(personRepository.getAllPersons())
        .thenAnswer((_) => Future.value(persons));
  });

  blocTest<CommentBloc, CommentState>('initial',
      build: () => bloc,
      act: (bloc) => bloc.add(const CommentEvent.initial()),
      wait: const Duration(milliseconds: 100),
      expect: () => [initialState]);

  blocTest<CommentBloc, CommentState>('filterChanged index 0 emit same state',
      build: () => bloc,
      act: (bloc) => bloc.add(const CommentEvent.filterComments(0)),
      seed: () => initialState,
      wait: const Duration(milliseconds: 100),
      verify: (_) {
        verify(personRepository.getAllPersons()).called(1);
        verify(commentRepository.getAllCommentsByStatus(true)).called(1);
        verifyNever(commentRepository.getAllCommentsByStatus(false));
      });

  blocTest<CommentBloc, CommentState>('filterChanged index 1',
      build: () => bloc,
      act: (bloc) => bloc.add(const CommentEvent.filterComments(1)),
      seed: () => initialState,
      wait: const Duration(milliseconds: 100),
      verify: (_) {
        verify(personRepository.getAllPersons()).called(1);
        verify(commentRepository.getAllCommentsByStatus(false)).called(1);
        verifyNever(commentRepository.getAllCommentsByStatus(true));
      },
      expect: () => [
            initialState.copyWith(
              status: CommentScreenState.data,
              selected: [false, true],
              commentsWithPerson: [
                CommentWithPerson(
                  comment: commentsDone[3],
                  person: persons[1],
                ),
              ],
            )
          ]);

  blocTest<CommentBloc, CommentState>('navigate to person',
      build: () => bloc,
      act: (bloc) => bloc.add(CommentEvent.navigatePerson(persons[0])),
      seed: () => initialState,
      wait: const Duration(milliseconds: 100),
      expect: () => [
            initialState.copyWith(
                status: CommentScreenState.navigateToPerson,
                selectedPerson: persons[0])
          ]);
}
