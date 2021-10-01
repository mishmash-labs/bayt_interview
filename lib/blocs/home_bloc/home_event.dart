part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class FetchTodos extends HomeEvent {
  final String search;
  final String? filter;
  final String? sort;

  FetchTodos(this.search, this.filter, this.sort);
}

class ResetTodos extends HomeEvent {
  final String search;
  final String? filter;
  final String? sort;

  ResetTodos(this.search, this.filter, this.sort);
}
