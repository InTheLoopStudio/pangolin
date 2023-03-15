import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this.searchRepository,
    required this.database,
  }) : super(SearchState());

  final SearchRepository searchRepository;
  final DatabaseRepository database;

  void searchUsersByUsername(String input) {
    if (input.isNotEmpty) {
      emit(state.copyWith(loading: true, searchTerm: input));
      const duration = Duration(milliseconds: 500);
      Timer(duration, () async {
        if (input.isNotEmpty && input == state.searchTerm) {
          // input hasn't changed in the last 500 milliseconds..
          // you can start search
          // print('Now !!! search term : ${state.searchTerm}');
          final searchRes = await searchRepository.queryUsers(state.searchTerm);
          // print('RESULTS: $searchRes');
          emit(state.copyWith(searchResults: searchRes, loading: false));
        } else {
          //wait.. Because user still writing..        print('Not Now');
          // print('Not Now');
        }
      });
    } else {
      emit(state.copyWith(loading: false, searchTerm: '', searchResults: []));
    }
  }

  void searchLocations(String query) {
    if (query.isNotEmpty) {
      emit(state.copyWith(loading: true, searchTerm: query));
      const duration = Duration(milliseconds: 500);
      Timer(duration, () async {
        if (query.isNotEmpty && query == state.searchTerm) {
          // input hasn't changed in the last 500 milliseconds..
          // you can start search
          // print('Now !!! search term : ${state.searchTerm}');

          // TODO: search for places
          // TODO: emit results
        } else {
          //wait.. Because user still writing..        print('Not Now');
          // print('Not Now');
        }
      });
    } else {
      emit(
        state.copyWith(
          loading: false,
          searchTerm: '',
          searchResultsByLocation: [],
        ),
      );
    }
  }

  Future<void> searchUsersByPlace(String placeId) async {
    emit(state.copyWith(loading: true));
    // input hasn't changed in the last 500 milliseconds..
    // you can start search
    // print('Now !!! search term : ${state.searchTerm}');

    // TODO: get `Place` object for selected place
    // final place = await database.getPlaceById(placeId);
    const place = Place(latLng: LatLng(lat: rvaLat, lng: rvaLng));
    final searchRes = await database.searchUsersByLocation(
      lat: place.latLng?.lat ?? rvaLat,
      lng: place.latLng?.lng ?? rvaLng,
    );
    emit(state.copyWith(searchResultsByLocation: searchRes, loading: false));
  }
}
