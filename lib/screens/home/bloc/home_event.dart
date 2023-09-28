part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class OrdersButtonClickEvent extends HomeEvent {}
class FaqButtonClickEvent extends HomeEvent {}
class CommentsButtonClickEvent extends HomeEvent {}
