part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeNavigateOrders extends HomeState {}
class HomeNavigateFaq extends HomeState {}
class HomeNavigateComments extends HomeState {}
