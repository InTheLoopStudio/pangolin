import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';
import 'package:intheloopapp/ui/widgets/search_view/discover_view.dart';

class ByUsernameResultsList extends StatelessWidget {
  const ByUsernameResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(
            child: SpinKitWave(
              color: Colors.white,
              size: 25,
            ),
          );
        }

        if (state.searchTerm.isEmpty &&
            state.occupations.isEmpty &&
            state.genres.isEmpty &&
            state.labels.isEmpty &&
            state.place == null &&
            state.placeId == null) {
          return const DiscoverView();
        } else if (state.searchResults.isEmpty) {
          return const Center(
            child: Text('No users found'),
          );
        } else {
          return ListView.builder(
            itemCount: state.searchResults.length,
            itemBuilder: (BuildContext context, int index) {
              return UserTile(user: state.searchResults[index]);
            },
          );
        }
      },
    );
  }
}
