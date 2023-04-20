import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/search/search_cubit.dart';
import 'package:intheloopapp/ui/widgets/messaing_view/search_bar.dart';

class TappedSearchBar extends StatelessWidget {
  const TappedSearchBar({
    required this.searchFocusNode,
    super.key,
  });

  final FocusNode searchFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return CupertinoSearchTextField(
          focusNode: searchFocusNode,
          style: const TextStyle(
            color: Colors.white,
          ),
          controller: state.textController,
          onChanged: (input) {
            context.read<SearchCubit>().search(input);
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
