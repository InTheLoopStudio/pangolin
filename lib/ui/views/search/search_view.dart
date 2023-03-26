import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/search/search_cubit.dart';
import 'package:intheloopapp/ui/widgets/search_view/by_location_results_list.dart';
import 'package:intheloopapp/ui/widgets/search_view/by_username_results_list.dart';
import 'package:intheloopapp/ui/widgets/search_view/search_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  late final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchRepository = RepositoryProvider.of<SearchRepository>(context);
    final database = RepositoryProvider.of<DatabaseRepository>(context);
    final places = RepositoryProvider.of<PlacesRepository>(context);

    return BlocProvider(
      create: (context) => SearchCubit(
        searchRepository: searchRepository,
        database: database,
        places: places,
        tabController: tabController,
      )..initTabController(),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: theme.colorScheme.background,
          title: const SearchBar(),
          bottom: TabBar(
            controller: tabController,
            indicatorColor: tappedAccent,
            labelColor: tappedAccent,
            tabs: const [
              Tab(child: Text('Username')),
              Tab(child: Text('Location')),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            Center(
              child: ByUsernameResultsList(),
            ),
            Center(
              child: ByLocationResultsList(),
            ),
          ],
        ),
      ),
    );
  }
}
