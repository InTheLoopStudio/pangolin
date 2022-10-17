import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/ui/views/search/search_cubit.dart';
import 'package:intheloopapp/ui/widgets/search_view/results_list.dart';
import 'package:intheloopapp/ui/widgets/search_view/search_bar.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchRepository = RepositoryProvider.of<SearchRepository>(context);

    return BlocProvider(
      create: (context) => SearchCubit(
        searchRepository: searchRepository,
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: theme.colorScheme.background,
          title: const SearchBar(),
        ),
        body: const Center(
          child: ResultsList(),
        ),
      ),
    );
  }
}
