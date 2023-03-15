import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/ui/widgets/common/forms/location_form/location_cubit.dart';
import 'package:intheloopapp/utils.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({
    required this.initialPlace,
    Key? key,
  }) : super(key: key);

  final Place initialPlace;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return CupertinoSearchTextField(
          placeholder: formattedAddress(initialPlace.addressComponents),
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (input) {
            context.read<LocationCubit>().searchLocations(input);
          },
        );
      },
    );
  }
}
