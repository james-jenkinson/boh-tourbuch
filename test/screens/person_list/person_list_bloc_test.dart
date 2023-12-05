import 'package:bloc_test/bloc_test.dart';
import 'package:boh_tourbuch/models/person.dart';
import 'package:boh_tourbuch/repository/person_repository.dart';
import 'package:boh_tourbuch/screens/person_list/bloc/person_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<PersonRepository>()])
import 'person_list_bloc_test.mocks.dart';

const p0 = Person(id: 0, name: 'p0');
const p1 = Person(id: 1, name: 'p1');
const pX = Person(id: 2, name: 'x');
const newPerson = Person(id: 42, name: 'new42');
const PersonListState loadPersonsState = PersonListState(
    status: PersonListStatus.data,
    persons: [p0, p1, pX],
    filteredPersons: [p0, p1, pX]);

void main() {
  late PersonListBloc bloc;
  late MockPersonRepository repo;

  setUp(() {
    repo = MockPersonRepository();
    bloc = PersonListBloc(repo);
    when(repo.getAllPersons()).thenAnswer((_) => Future(() => [p0, p1, pX]));
    when(repo.createPerson(any)).thenAnswer((_) => Future(() => 42));
    when(repo.getPersonById(any)).thenAnswer((_) => Future(() => newPerson));
  });

  group('Test static', () {
    test('apply filter on empty list', () {
      expect(PersonListBloc.applyFilter([], ''), <Person>[]);
      expect(PersonListBloc.applyFilter([], 'x'), <Person>[]);
    });

    test('apply filter on empty filter', () {
      expect(PersonListBloc.applyFilter([p0, p1], ''), <Person>[p0, p1]);
    });

    test('apply filter on filter', () {
      expect(PersonListBloc.applyFilter([p0, p1, pX], 'x'), <Person>[pX]);
      expect(PersonListBloc.applyFilter([p0, p1, pX], 'p'), <Person>[p1, p0]);
      expect(PersonListBloc.applyFilter([p0, p1, pX], 'z'), <Person>[]);
    });
  });

  group('Test events', () {
    blocTest<PersonListBloc, PersonListState>('loadPersons',
        build: () => bloc,
        act: (bloc) => bloc.add(const PersonListEvent.loadPersons()),
        expect: () => [loadPersonsState]);

    blocTest<PersonListBloc, PersonListState>('updateFilter',
        build: () => bloc,
        seed: () => loadPersonsState,
        act: (bloc) => bloc.add(const PersonListEvent.updateFilter('p')),
        expect: () => [
              loadPersonsState.copyWith(
                filteredPersons: [p1, p0],
                filter: 'p',
              )
            ]);

    blocTest<PersonListBloc, PersonListState>('setPersonSelectedAndOpenEdit',
        build: () => bloc,
        seed: () => loadPersonsState,
        act: (bloc) =>
            bloc.add(const PersonListEvent.setPersonSelectedAndOpenEdit(pX)),
        expect: () => [
              loadPersonsState.copyWith(
                status: PersonListStatus.editSelectedPersons,
                selectedPersons: [pX],
              )
            ]);

    final stateWithFilter = loadPersonsState.copyWith(filter: 'newName');
    blocTest<PersonListBloc, PersonListState>(
      'addPerson',
      build: () => bloc,
      seed: () => stateWithFilter,
      act: (bloc) => bloc..add(const PersonListEvent.addPerson()),
      wait: const Duration(milliseconds: 1),
      expect: () => [
        stateWithFilter.copyWith(
            status: PersonListStatus.navigateToSelected,
            selectedPersons: [newPerson])
      ],
    );

    blocTest<PersonListBloc, PersonListState>(
      'navigateToPerson',
      build: () => bloc,
      seed: () => loadPersonsState,
      act: (bloc) => bloc.add(const PersonListEvent.navigateToPerson(p0)),
      expect: () => [
        loadPersonsState.copyWith(
          status: PersonListStatus.navigateToSelected,
          selectedPersons: [p0],
        )
      ],
    );

    blocTest<PersonListBloc, PersonListState>(
      'togglePerson with empty',
      build: () => bloc,
      seed: () => loadPersonsState.copyWith(selectedPersons: []),
      act: (bloc) => bloc.add(const PersonListEvent.togglePerson(p0)),
      expect: () => [
        loadPersonsState.copyWith(
          selectedPersons: [p0],
        )
      ],
    );

    blocTest<PersonListBloc, PersonListState>(
      'togglePerson with 1 entry',
      build: () => bloc,
      seed: () => loadPersonsState.copyWith(selectedPersons: [p0]),
      act: (bloc) => bloc.add(const PersonListEvent.togglePerson(p1)),
      expect: () => [
        loadPersonsState.copyWith(
          selectedPersons: [p0, p1],
        )
      ],
    );

    blocTest<PersonListBloc, PersonListState>(
      'togglePerson with same entry',
      build: () => bloc,
      seed: () => loadPersonsState.copyWith(selectedPersons: [p0]),
      act: (bloc) => bloc.add(const PersonListEvent.togglePerson(p0)),
      expect: () => [
        loadPersonsState.copyWith(
          selectedPersons: [],
        )
      ],
    );

    blocTest<PersonListBloc, PersonListState>(
      'setPersonSelectedAndOpenEdit with empty',
      build: () => bloc,
      seed: () => loadPersonsState.copyWith(selectedPersons: []),
      act: (bloc) => bloc.add(const PersonListEvent.setPersonSelectedAndOpenEdit(p0)),
      expect: () => [
        loadPersonsState.copyWith(
          status: PersonListStatus.editSelectedPersons,
          selectedPersons: [p0],
        )
      ],
    );

    blocTest<PersonListBloc, PersonListState>(
      'setPersonSelectedAndOpenEdit with 1 entry',
      build: () => bloc,
      seed: () => loadPersonsState.copyWith(selectedPersons: [p0]),
      act: (bloc) => bloc.add(const PersonListEvent.setPersonSelectedAndOpenEdit(p1)),
      expect: () => [
        loadPersonsState.copyWith(
          status: PersonListStatus.editSelectedPersons,
          selectedPersons: [p0, p1],
        )
      ],
    );

    blocTest<PersonListBloc, PersonListState>(
      'clearSelection',
      build: () => bloc,
      seed: () => loadPersonsState.copyWith(status: PersonListStatus.navigateToSelected, selectedPersons: [p0]),
      act: (bloc) => bloc.add(const PersonListEvent.clearSelection()),
      expect: () => [
        loadPersonsState.copyWith(
          status: PersonListStatus.data,
          selectedPersons: [],
        )
      ],
    );
  });
}
