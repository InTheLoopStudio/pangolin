import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/messaging/new_chat/new_chat_cubit.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewChatCubit, NewChatState>(
      builder: (context, state) {
        return CupertinoSearchTextField(
          controller: state.textController,
          onChanged: (input) {
            if (input.isNotEmpty) {
              context.read<NewChatCubit>().searchUsers(input);
            }
          },
        );
        // title: TextField(
        //   controller: _searchController,
        //   style: TextStyle(color: Colors.white),
        //   decoration: InputDecoration(
        //     contentPadding: EdgeInsets.symmetric(vertical: 15),
        //     hintText: 'Search...',
        //     hintStyle: TextStyle(color: Colors.white),
        //     border: InputBorder.none,
        //     prefixIcon: Icon(Icons.search, color: Colors.white),
        //     suffixIcon: IconButton(
        //       icon: Icon(Icons.clear, color: Colors.white),
        //       onPressed: () {
        //         clearSearch();
        //       },
        //     ),
        //     filled: true,
        //   ),
        //   onChanged: (input) {
        //     if (input.isNotEmpty) {
        //       setState(() {
        //         _users = DatabaseService.searchUsers(input);
        //       });
        //     }
        //   },
        // ),
      },
    );
  }
}
