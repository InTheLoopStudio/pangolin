import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container.dart';

class ByLoopResultsList extends StatelessWidget {
  const ByLoopResultsList({super.key});

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
                  'Search Loop',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          );
        } else if (state.loopSearchResults.isEmpty) {
          return const Center(
            child: Text('No loops found'),
          );
        } else {
          return ListView.builder(
            itemCount: state.loopSearchResults.length,
            itemBuilder: (BuildContext context, int index) {
              return LoopContainer(loop: state.loopSearchResults[index]);
            },
          );
        }
      },
    );
  }
}
