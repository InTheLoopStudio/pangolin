import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/forms/location_text_field.dart';

class LocationFilter extends StatelessWidget {
  const LocationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return LocationTextField(
          initialPlaceId: state.placeId,
          initialPlace: state.place,
          onChanged: (place, placeId) {
            context.read<SearchBloc>().add(
                  SetAdvancedSearchFilters(
                    place: place,
                    placeId: placeId,
                  ),
                );
          },
        );
      },
    );
  }
}
