import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/widgets/search_view/by_location_results_list.dart';
import 'package:intheloopapp/ui/widgets/search_view/by_loop_results_list.dart';
import 'package:intheloopapp/ui/widgets/search_view/by_username_results_list.dart';
import 'package:intheloopapp/ui/widgets/search_view/tapped_search_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({
    required this.searchFocusNode,
    super.key,
  });

  final FocusNode searchFocusNode;

  @override
  // ignore: library_private_types_in_public_api
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();
  }

  void _handleTabChange() {
    context.read<SearchBloc>().add(
          ChangeSearchTab(index: _tabController.index),
        );
  }

  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: theme.colorScheme.background,
        title: TappedSearchBar(
          searchFocusNode: widget.searchFocusNode,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.doc_text_search),
            color: tappedAccent,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: tappedAccent,
          labelColor: tappedAccent,
          tabs: const [
            Tab(child: Text('Username')),
            Tab(child: Text('Location')),
            Tab(child: Text('Loop')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(
            child: ByUsernameResultsList(),
          ),
          Center(
            child: ByLocationResultsList(),
          ),
          Center(
            child: ByLoopResultsList(),
          ),
        ],
      ),
    );
  }
}
