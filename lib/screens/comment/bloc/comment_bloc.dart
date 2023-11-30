import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/person.dart';
import '../../../repository/comment_repository.dart';
import '../../../repository/person_repository.dart';
import '../model/comment_with_person.dart';

part 'comment_bloc.freezed.dart';
part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository _commentRepository;
  final PersonRepository _personRepository;

  CommentBloc(this._commentRepository, this._personRepository)
      : super(const CommentState()) {
    on<CommentEvent>((event, emit) async {
      await event.when(
          initial: () async {
            emit(state.copyWith(
                status: CommentScreenState.data,
                commentsWithPerson:
                    await getCommentsWithPerson(state.selected[0])));
          },
          filterComments: (int selectedIndex) async {
            emit(
              state.copyWith(
                  commentsWithPerson:
                      await getCommentsWithPerson(selectedIndex == 0),
                  // index 0: isOpen, index 1: isDone
                  selected: [selectedIndex == 0, selectedIndex != 0]),
            );
          },
          navigatePerson: (Person person) async {
            emit(state.copyWith(
                selectedPerson: person,
                status: CommentScreenState.navigateToPerson));
          });
    });
  }

  Future<List<CommentWithPerson>> getCommentsWithPerson(bool done) async {
    final List<Person> persons = await _personRepository.getAllPersons();
    final List<CommentWithPerson> commentsAndPerson =
        (await _commentRepository.getAllCommentsByStatus(done))
            .map((comment) => CommentWithPerson(comment: comment,
                person: persons.firstWhere((person) => person.id == comment.personId)))
            .toList();
    return commentsAndPerson;
  }
}
