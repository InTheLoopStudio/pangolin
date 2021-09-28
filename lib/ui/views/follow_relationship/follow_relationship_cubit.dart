import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'follow_relationship_state.dart';

class FollowRelationshipCubit extends Cubit<FollowRelationshipState> {
  FollowRelationshipCubit({
    required this.databaseRepository,
    required this.visitedUserId,
  }) : super(FollowRelationshipState());

  final DatabaseRepository databaseRepository;
  final String visitedUserId;

  Future<void> initFollowers() async {
    List<UserModel> followerUser =
        await databaseRepository.getFollowers(visitedUserId);

    emit(state.copyWith(followers: followerUser));
  }

  Future<void> initFollowing() async {
    List<UserModel> followingUser =
        await databaseRepository.getFollowing(visitedUserId);

    emit(state.copyWith(following: followingUser));
  }
}
