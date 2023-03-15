import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({
    required this.initialPlace,
    required this.places,
    required this.navigationBloc,
    required this.onSelected,
  }) : super(const LocationState());

  final Place initialPlace;
  final PlacesRepository places;
  final void Function(Place?, String) onSelected;

  final NavigationBloc navigationBloc;

  Future<void> searchLocations(String input) async {
    if (input.isNotEmpty) {
      emit(state.copyWith(loading: true, query: input));
      const duration = Duration(milliseconds: 500);
      Timer(duration, () async {
        if (input.isNotEmpty && input == state.query) {
          // input hasn't changed in the last 500 milliseconds..
          // you can start search
          // print('Now !!! search term : ${state.searchTerm}');
          final searchRes = await places.searchPlace(state.query);
          // print('RESULTS: $searchRes');
          emit(state.copyWith(locationResults: searchRes, loading: false));
        } else {
          //wait.. Because user still writing..        print('Not Now');
          // print('Not Now');
        }
      });
    } else {
      emit(state.copyWith(loading: false, query: '', locationResults: []));
    }
  }

  Future<void> saveLocation(AutocompletePrediction prediction) async {
    final placeId = prediction.placeId;
    final place = await places.getPlaceById(placeId);

    onSelected(place, placeId);

    navigationBloc.add(const Pop());
  }
}
