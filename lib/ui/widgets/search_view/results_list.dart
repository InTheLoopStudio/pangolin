import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intheloopapp/ui/views/search/search_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';

class ResultsList extends StatelessWidget {
  const ResultsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.loading) {
          return Center(
            child: SpinKitWave(
              color: Colors.white,
              size: 25.0,
              duration: const Duration(milliseconds: 1200),
            ),
          );
        }

        if (state.searchTerm.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 200),
                Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        } else if (state.searchResults.isEmpty) {
          return Center(
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
