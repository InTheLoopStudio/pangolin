import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'feeds_list_state.dart';

class FeedsListCubit extends Cubit<FeedsListState> {
  FeedsListCubit() : super(FeedsListState());

  @override
  Future<void> close() async {
    state.pageController.dispose();
    await super.close();
  }

  void feedChanged(int index) {
    emit(state.copyWith(currentIndex: index));

    state.pageController.jumpToPage(state.currentIndex);
  }
}
