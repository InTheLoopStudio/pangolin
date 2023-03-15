import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intheloopapp/ui/views/search/search_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';

class ByUsernameResultsList extends StatelessWidget {
  const ByUsernameResultsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(
            child: SpinKitWave(
              color: Colors.white,
              size: 25,
            ),
          );
        }

        if (state.searchTerm.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 200,
                  color: Color(0xFF757575),
                ),
                Text(
                  'Search Artist Name',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          );
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
