import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/post.dart';

part 'post_feed_state.dart';

class PostFeedCubit extends Cubit<PostFeedState> {
  PostFeedCubit({
    required this.currentUserId,
    required this.databaseRepository,
  }) : super(const PostFeedState());

  final String currentUserId;
  final DatabaseRepository databaseRepository;
  StreamSubscription<Post>? postListener;

  Future<void> initPosts({bool clearPosts = true}) async {
    await postListener?.cancel();
    if (clearPosts) {
      emit(
        state.copyWith(
          status: PostFeedStatus.initial,
          posts: [],
          hasReachedMax: false,
        ),
      );
    }

    final followingPosts = await databaseRepository.getFollowingPosts(
      currentUserId,
      limit: 1,
    );
    if (followingPosts.isEmpty) {
      emit(state.copyWith(status: PostFeedStatus.success));
    }

    postListener = databaseRepository
        .followingPostsObserver(currentUserId)
        .listen((Post event) {
      // print('post { ${event.id} : ${event.title} }');
      emit(
        state.copyWith(
          status: PostFeedStatus.success,
          posts: List.of(state.posts)..insert(0, event),
        ),
      );
    });
  }

  Future<void> fetchMorePosts() async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == PostFeedStatus.initial) {
        await initPosts();
      }

      final posts = await databaseRepository.getFollowingPosts(
        currentUserId,
        lastPostId: state.posts.last.id,
      );
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: PostFeedStatus.success,
                posts: List.of(state.posts)..insertAll(0, posts),
                hasReachedMax: false,
              ),
            );
    } on Exception {
      emit(state.copyWith(status: PostFeedStatus.failure));
    }
  }

  @override
  Future<void> close() async {
    await postListener?.cancel();
    await super.close();
  }
}
