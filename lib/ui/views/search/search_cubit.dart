import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.searchRepository}) : super(SearchState());

  final SearchRepository searchRepository;

  void searchUsers(String input) {
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
    }
  }
}
