import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';

class TappedSearchBar extends StatelessWidget {
  const TappedSearchBar({
    required this.searchFocusNode,
    super.key,
  });

  final FocusNode searchFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return CupertinoSearchTextField(
          focusNode: searchFocusNode,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (input) {
            context.read<SearchBloc>().add(Search(query: input));
          },
        );
      },
    );
  }
}
