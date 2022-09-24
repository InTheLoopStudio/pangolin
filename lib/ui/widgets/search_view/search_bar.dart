import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/search/search_cubit.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return CupertinoSearchTextField(
          controller: state.textController,
          onChanged: (input) {
            context.read<SearchCubit>().searchUsers(input);
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
