import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/widgets/settings_view/genre_selection.dart';

class GenreFilter extends StatelessWidget {
  const GenreFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return GenreSelection(
          initialValue: state.genres,
          onConfirm: (values) {
            context.read<SearchBloc>().add(
                  SetAdvancedSearchFilters(
                    genres: values
                        .where(
                          (element) => element != null,
                        )
                        .whereType<Genre>()
                        .toList(),
                  ),
                );
          },
        );
      },
    );
  }
}
