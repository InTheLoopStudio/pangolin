import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intheloopapp/ui/views/messaging/new_chat/new_chat_cubit.dart';
import 'package:intheloopapp/ui/widgets/messaing_view/user_tile.dart';

class ResultsList extends StatelessWidget {
  const ResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewChatCubit, NewChatState>(
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
