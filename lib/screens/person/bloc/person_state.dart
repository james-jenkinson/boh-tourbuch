part of 'person_bloc.dart';

@immutable
abstract class PersonState {}

class PersonInitial extends PersonState {}

class PersonLoaded extends PersonState {
  final Person selectedPerson;
  final List<ProductOrderWithSymbol> productOrdersWithSymbols;
  final List<Comment> comments;

  PersonLoaded(this.selectedPerson, this.productOrdersWithSymbols, this.comments);
}
