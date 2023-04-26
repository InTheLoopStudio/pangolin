import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/widgets/settings_view/occupation_selection.dart';

class OccupationFilter extends StatelessWidget {
  const OccupationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return OccupationSelection(
          initialValue: state.occupations,
          onConfirm: (values) {
            context.read<SearchBloc>().add(
                  SetAdvancedSearchFilters(
                    occupations: values
                        .where(
                          (element) => element != null,
                        )
                        .whereType<String>()
                        .toList(),
                  ),
                );
          },
        );
      },
    );
  }
}
