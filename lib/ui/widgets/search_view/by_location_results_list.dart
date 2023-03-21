import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intheloopapp/ui/views/search/search_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';

class ByLocationResultsList extends StatelessWidget {
  const ByLocationResultsList({super.key});

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
                  'Search Location',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          );
        } else if (state.searchResultsByLocation.isEmpty) {
          if (state.locationResults.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          return ListView.builder(
            itemCount: state.locationResults.length,
            itemBuilder: (BuildContext context, int index) {
              final prediction = state.locationResults[index];
              return ListTile(
                onTap: () {
                  context
                      .read<SearchCubit>()
                      .searchUsersByPrediction(prediction);
                },
                leading: const Icon(CupertinoIcons.location_fill),
                title: Text(prediction.primaryText),
                subtitle: Text(prediction.secondaryText),
              );
            },
          );
        } else {
          return ListView.builder(
            itemCount: state.searchResultsByLocation.length,
            itemBuilder: (BuildContext context, int index) {
              return UserTile(user: state.searchResultsByLocation[index]);
            },
          );
        }
      },
    );
  }
}
