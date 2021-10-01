import 'package:bayt/models/todos_model.dart';
import 'package:bayt/network/api_calls.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<FetchTodos>(_onTodosFetched, transformer: droppable());
    on<ResetTodos>(_onTodosReset, transformer: droppable());
  }

  int pageNumber = 1;
  var todosList = <TodosModel>[];

  final ApiClient _apiClient = ApiClient();

  void _onTodosFetched(FetchTodos event, Emitter<HomeState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == HomeStatus.initial) {
        final todos = await _apiClient.fetchTodos(
            0, event.sort, event.search, event.filter);
        return emit(state.copyWith(
          status: HomeStatus.success,
          todos: todos,
          hasReachedMax: false,
        ));
      }
      final todos = await _apiClient.fetchTodos(
          state.todos.length, event.sort, event.search, event.filter);
      emit(todos.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: HomeStatus.success,
              todos: List.of(state.todos)..addAll(todos),
              hasReachedMax: false,
            ));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  void _onTodosReset(ResetTodos event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      status: HomeStatus.initial,
      todos: [],
      hasReachedMax: false,
    ));
    final todos =
        await _apiClient.fetchTodos(0, event.sort, event.search, event.filter);
    return emit(state.copyWith(
      status: HomeStatus.success,
      todos: todos,
      hasReachedMax: false,
    ));
  }
}
