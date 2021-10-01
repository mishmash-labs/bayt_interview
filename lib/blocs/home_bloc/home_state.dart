part of 'home_bloc.dart';

@immutable
class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.todos = const <TodosModel>[],
    this.hasReachedMax = false,
  });

  final bool hasReachedMax;
  final HomeStatus status;
  final List<TodosModel> todos;

  HomeState copyWith({
    HomeStatus? status,
    List<TodosModel>? todos,
    bool? hasReachedMax,
  }) {
    return HomeState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

enum HomeStatus { initial, success, failure }
