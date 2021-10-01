import 'package:bayt/utils/translate_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../blocs/home_bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc homeBloc = HomeBloc();

  final _scrollController = ScrollController();
  String? filter = '';
  String search = '';
  String? sort = '';

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) homeBloc.add(FetchTodos(search, filter, sort));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.home)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                label: Text(translate(Keys.search)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (val) {
                search = val;
                homeBloc.add(ResetTodos(search, filter, sort));
              },
            ),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              Text(translate(Keys.filter)),
              Radio<String>(
                  value: 'false',
                  groupValue: filter,
                  onChanged: (val) {
                    setState(() {
                      filter = val;
                    });
                    homeBloc.add(ResetTodos(search, filter, sort));
                  }),
              Text(translate(Keys.incomplete)),
              Radio<String>(
                  value: 'true',
                  groupValue: filter,
                  onChanged: (val) {
                    setState(() {
                      filter = val;
                    });
                    homeBloc.add(ResetTodos(search, filter, sort));
                  }),
              Text(translate(Keys.completed)),
              Radio<String>(
                  value: '',
                  groupValue: filter,
                  onChanged: (val) {
                    setState(() {
                      filter = val;
                    });
                    homeBloc.add(ResetTodos(search, filter, sort));
                  }),
              Text(translate(Keys.all)),
            ]),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              Text(translate(Keys.sort)),
              Radio<String>(
                  value: 'asc',
                  groupValue: sort,
                  onChanged: (val) {
                    setState(() {
                      sort = val;
                    });
                    homeBloc.add(ResetTodos(search, filter, sort));
                  }),
              Text(translate(Keys.descending)),
              Radio<String>(
                  value: 'desc',
                  groupValue: sort,
                  onChanged: (val) {
                    setState(() {
                      sort = val;
                    });
                    homeBloc.add(ResetTodos(search, filter, sort));
                  }),
              Text(translate(Keys.ascending)),
              Radio<String>(
                  value: '',
                  groupValue: sort,
                  onChanged: (val) {
                    setState(() {
                      sort = val;
                    });
                    homeBloc.add(ResetTodos(search, filter, sort));
                  }),
              Text(translate(Keys.normal)),
            ]),
            Expanded(
              child: BlocBuilder(
                bloc: homeBloc..add(FetchTodos(search, filter, sort)),
                builder: (context, HomeState state) {
                  switch (state.status) {
                    case HomeStatus.failure:
                      return Center(child: Text(translate(Keys.failedtodos)));
                    case HomeStatus.success:
                      if (state.todos.isEmpty) {
                        return Center(child: Text(translate(Keys.notodos)));
                      }
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return index >= state.todos.length
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator()),
                                  ),
                                )
                              : ListTile(
                                  title: Text(state.todos[index].title),
                                  subtitle: Text(state.todos[index].completed
                                      ? translate(Keys.completed)
                                      : translate(Keys.incomplete)),
                                );
                        },
                        itemCount: state.hasReachedMax
                            ? state.todos.length
                            : state.todos.length + 1,
                        controller: _scrollController,
                      );
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
