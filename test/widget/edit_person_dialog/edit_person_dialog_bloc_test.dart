import 'package:bloc_test/bloc_test.dart';
import 'package:boh_tourbuch/models/person.dart';
import 'package:boh_tourbuch/repository/person_repository.dart';
import 'package:boh_tourbuch/widgets/edit_person_dialog/bloc/edit_person_dialog_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<PersonRepository>()])
import 'edit_person_dialog_bloc_test.mocks.dart';

const p0 = Person(id: 0, name: 'p0');

void main() {
  late MockPersonRepository repo;
  late EditPersonDialogBloc bloc;
  late EditPersonDialogState editState;

  setUp(() {
    repo = MockPersonRepository();
    bloc = EditPersonDialogBloc(repo);
    editState =
        const EditPersonDialogState(status: EditPersonDialogStatus.edit);

    when(repo.updatePerson(any)).thenAnswer((_) => Future(() => 1));
    when(repo.mergePersons(any, any)).thenAnswer((_) => Future(() => p0));
  });

  group('Test events', () {
    blocTest<EditPersonDialogBloc, EditPersonDialogState>('setPerson',
        build: () => bloc,
        act: (bloc) => bloc.add(const EditPersonDialogEvent.setPerson(
              Person(
                id: 3,
                name: 'peter',
                comment: 'yo',
                blockedSince: null,
              ),
              null,
            )),
        expect: () => [
              const EditPersonDialogState(
                  id: 3,
                  name: 'peter',
                  comment: 'yo',
                  blockedSince: null,
                  status: EditPersonDialogStatus.edit,
                  personToMerge: null)
            ]);

    const testPerson = Person(name: 'testPerson', comment: 'testComment');
    blocTest<EditPersonDialogBloc, EditPersonDialogState>(
        'setPerson with merge',
        build: () => bloc,
        act: (bloc) => bloc.add(const EditPersonDialogEvent.setPerson(
              Person(
                id: 3,
                name: 'peter',
                comment: 'yo',
                blockedSince: null,
              ),
              testPerson,
            )),
        expect: () => [
              const EditPersonDialogState(
                  id: 3,
                  name: 'peter / testPerson',
                  comment: 'yo / testComment',
                  blockedSince: null,
                  status: EditPersonDialogStatus.edit,
                  personToMerge: testPerson)
            ]);

    blocTest<EditPersonDialogBloc, EditPersonDialogState>('updateName',
        build: () => bloc,
        seed: () => editState,
        act: (bloc) =>
            bloc.add(const EditPersonDialogEvent.updateName('newName')),
        expect: () => [editState.copyWith(name: 'newName')]);

    blocTest<EditPersonDialogBloc, EditPersonDialogState>('updateComment',
        build: () => bloc,
        seed: () => editState,
        act: (bloc) =>
            bloc.add(const EditPersonDialogEvent.updateComment('newComment')),
        expect: () => [editState.copyWith(comment: 'newComment')]);

    blocTest<EditPersonDialogBloc, EditPersonDialogState>(
        'updateBlocked set blocked',
        build: () => bloc,
        seed: () => editState.copyWith(blockedSince: null),
        act: (bloc) =>
            bloc.add(const EditPersonDialogEvent.updateBlocked(true)),
        verify: (newState) =>
            expect(newState.state.blockedSince, (DateTime? v) => v != null));

    blocTest<EditPersonDialogBloc, EditPersonDialogState>(
        'updateBlocked set unblocked',
        build: () => bloc,
        seed: () => editState.copyWith(blockedSince: DateTime.now()),
        act: (bloc) =>
            bloc.add(const EditPersonDialogEvent.updateBlocked(false)),
        verify: (newState) =>
            expect(newState.state.blockedSince, (DateTime? v) => v == null));

    blocTest<EditPersonDialogBloc, EditPersonDialogState>('trigger save event',
        build: () => bloc,
        seed: () => editState,
        act: (bloc) => bloc.add(const EditPersonDialogEvent.save()),
        expect: () => [editState.copyWith(status: EditPersonDialogStatus.save)],
        verify: (_) {
          verify(repo.updatePerson(any)).called(1);
          verifyNever(repo.mergePersons(any, any));
        });

    blocTest<EditPersonDialogBloc, EditPersonDialogState>(
        'trigger save event with merge',
        build: () => bloc,
        seed: () => editState.copyWith(personToMerge: p0),
        act: (bloc) => bloc.add(const EditPersonDialogEvent.save()),
        expect: () => [
              editState.copyWith(
                status: EditPersonDialogStatus.save,
                personToMerge: p0,
              )
            ],
        verify: (_) {
          verifyNever(repo.updatePerson(any));
          verify(repo.mergePersons(any, any)).called(1);
        });

    blocTest<EditPersonDialogBloc, EditPersonDialogState>('set cancel',
        build: () => bloc,
        seed: () => editState,
        act: (bloc) => bloc.add(const EditPersonDialogEvent.cancel()),
        expect: () =>
            [editState.copyWith(status: EditPersonDialogStatus.cancel)],
        verify: (_) => verifyNever(repo.updatePerson(any)));
  });
}
