part of 'person_bloc.dart';

enum PersonScreenState { initial, data, navigateHome }

@freezed
class PersonState with _$PersonState {
  const factory PersonState({
    @Default(PersonScreenState.initial) PersonScreenState status,
    required Person selectedPerson,
    @Default([]) List<ProductOrderWithSymbol> productOrdersWithSymbols,
    @Default([]) List<Comment> comments,
  }) = _PersonState;
}
