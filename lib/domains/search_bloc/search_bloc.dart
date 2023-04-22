import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required int initialIndex,
    required this.searchRepository,
    required this.database,
    required this.places,
  }) : super(
          SearchState(
            tabIndex: initialIndex,
          ),
        ) {
    on<ChangeSearchTab>((event, emit) async {
      emit(state.copyWith(tabIndex: event.index));
      if (state.lastRememberedSearchTerm != state.searchTerm) {
        emit(
          state.copyWith(
            lastRememberedSearchTerm: state.searchTerm,
          ),
        );
        await _search(state.searchTerm, emit);
      }
    });
    on<Search>((event, emit) async {
      await _search(event.query, emit);
    });
    on<SearchUsersByPrediction>((event, emit) async {
      await _searchUsersByPrediction(event.prediction, emit);
    });
  }

  Future<void> _search(String query, Emitter<SearchState> emit) async {
    switch (state.tabIndex) {
      case 0:
        await _searchUsersByUsername(query, emit);
        break;
      case 1:
        await _searchLocations(query, emit);
        break;
      case 2:
        await _searchLoops(query, emit);
        break;
    }
  }

  Future<void> _searchUsersByUsername(
    String input,
    Emitter<SearchState> emit,
  ) async {
    if (input.isNotEmpty) {
      emit(state.copyWith(loading: true, searchTerm: input));
      const duration = Duration(milliseconds: 500);
      final completer = Completer<void>();
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
        completer.complete();
      });
      await completer.future;
    } else {
      emit(
        state.copyWith(
          loading: false,
          searchTerm: '',
          searchResults: [],
        ),
      );
    }
  }

  Future<void> _searchLoops(
    String input,
    Emitter<SearchState> emit,
  ) async {
    if (input.isNotEmpty) {
      emit(state.copyWith(loading: true, searchTerm: input));
      const duration = Duration(milliseconds: 500);
      final completer = Completer<void>();
      Timer(duration, () async {
        if (input.isNotEmpty && input == state.searchTerm) {
          // input hasn't changed in the last 500 milliseconds..
          // you can start search
          // print('Now !!! search term : ${state.searchTerm}');
          final searchRes = await searchRepository.queryLoops(state.searchTerm);
          // print('RESULTS: $searchRes');
          emit(
            state.copyWith(
              loopSearchResults: searchRes,
              loading: false,
            ),
          );
        } else {
          //wait.. Because user still writing..        print('Not Now');
          // print('Not Now');
        }
        completer.complete();
      });
      await completer.future;
    } else {
      emit(
        state.copyWith(
          loading: false,
          searchTerm: '',
          loopSearchResults: [],
        ),
      );
    }
  }

  Future<void> _searchLocations(
    String query,
    Emitter<SearchState> emit,
  ) async {
    if (query.isNotEmpty) {
      emit(
        state.copyWith(
          loading: true,
          searchTerm: query,
          searchResultsByLocation: [],
        ),
      );
      const duration = Duration(milliseconds: 500);
      final completer = Completer<void>();
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
        completer.complete();
      });
      await completer.future;
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

  Future<void> _searchUsersByPrediction(
    AutocompletePrediction prediction,
    Emitter<SearchState> emit,
  ) async {
    final placeId = prediction.placeId;
    final mainText = prediction.primaryText;
    emit(state.copyWith(loading: true, searchTerm: mainText));

    final place = await places.getPlaceById(placeId);

    // TODO(jonaylor89): In the future, this should be paginated
    final searchRes = await database.searchUsersByLocation(
      lat: place?.latLng?.lat ?? 0,
      lng: place?.latLng?.lng ?? 0,
    );
    emit(
      state.copyWith(
        locationResults: [],
        searchResultsByLocation: searchRes,
        loading: false,
      ),
    );
  }

  final PlacesRepository places;
  final DatabaseRepository database;
  final SearchRepository searchRepository;
}
