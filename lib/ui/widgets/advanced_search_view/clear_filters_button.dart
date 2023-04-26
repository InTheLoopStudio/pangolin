import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';

class ClearFiltersButton extends StatelessWidget {
  const ClearFiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<SearchBloc>().add(ClearFilters());
      },
      child: const Text(
        'Clear Filters',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
