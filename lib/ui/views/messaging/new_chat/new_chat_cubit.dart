import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'new_chat_state.dart';

class NewChatCubit extends Cubit<NewChatState> {
  NewChatCubit({required this.searchRepository}) : super(NewChatState());

  final SearchRepository searchRepository;

  void searchUsers(String input) {
    if (input.length > 0) {
      emit(state.copyWith(loading: true, searchTerm: input));
      Duration duration = Duration(milliseconds: 500);
      Timer(duration, () async {
        if (input == state.searchTerm) {
          // input hasn't changed in the last 500 milliseconds..
          // you can start search
          print('Now !!! search term : ' + state.searchTerm);
          List<UserModel> searchRes =
              await searchRepository.queryUsers(state.searchTerm);
          print('RESULTS: $searchRes');
          emit(state.copyWith(searchResults: searchRes, loading: false));
        } else {
          //wait.. Because user still writing..        print('Not Now');
          print('Not Now');
        }
      });
    }
  }
}
