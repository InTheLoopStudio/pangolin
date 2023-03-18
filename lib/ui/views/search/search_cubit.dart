import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this.searchRepository,
    required this.database,
    required this.places,
    required this.tabController,
  }) : super(SearchState(tabController: tabController));

  final SearchRepository searchRepository;
  final DatabaseRepository database;
  final PlacesRepository places;
  final TabController tabController;

  void initTabController() {
    tabController.addListener(() {
      if (state.lastRememberedSearchTerm != state.searchTerm) {
        emit(
          state.copyWith(
            lastRememberedSearchTerm: state.searchTerm,
          ),
        );
        search(state.searchTerm);
      }
    });
  }

  void search(String query) {
    switch (tabController.index) {
      case 0:
        searchUsersByUsername(query);
        break;
      case 1:
        searchLocations(query);
        break;
    }
  }

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
      emit(
        state.copyWith(
          loading: true,
          searchTerm: query,
          searchResultsByLocation: [],
        ),
      );
      const duration = Duration(milliseconds: 500);
      Timer(duration, () async {
        if (query.isNotEmpty && query == state.searchTerm) {
          // input hasn't changed in the last 500 milliseconds..
          // you can start search
          // print('Now !!! search term : ${state.searchTerm}');

          final locationResults = await places.searchPlace(query);
          emit(
            state.copyWith(
              locationResults: locationResults,
              loading: false,
            ),
          );
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

  Future<void> searchUsersByPrediction(
    AutocompletePrediction prediction,
  ) async {
    final placeId = prediction.placeId;
    final mainText = prediction.primaryText;
    emit(state.copyWith(loading: true, searchTerm: mainText));
    // input hasn't changed in the last 500 milliseconds..
    // you can start search
    // print('Now !!! search term : ${state.searchTerm}');

    final place = await places.getPlaceById(placeId);

    // TODO(jonaylor89): In the future, this should be paginated
    final searchRes = await database.searchUsersByLocation(
      lat: place?.latLng?.lat ?? rvaLat,
      lng: place?.latLng?.lng ?? rvaLng,
    );
    emit(
      state.copyWith(
        locationResults: [],
        searchResultsByLocation: searchRes,
        loading: false,
      ),
    );
  }
}
