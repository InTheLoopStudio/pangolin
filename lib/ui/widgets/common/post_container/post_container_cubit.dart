import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/post.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'post_container_state.dart';

class PostContainerCubit extends Cubit<PostContainerState> {
  PostContainerCubit({
    required this.databaseRepository,
    required this.post,
    required this.currentUser,
  }) : super(PostContainerState(post: post));

  final DatabaseRepository databaseRepository;
  final UserModel currentUser;
  final Post post;

  Future<void> checkVerified() async {
    final verified = await databaseRepository.isVerified(post.userId);
    emit(
      state.copyWith(
        isVerified: verified,
      ),
    );
  }

  Future<void> initPostLikes() async {
    final isLiked = await databaseRepository.isLiked(
      currentUser.id,
      post.id,
      EntityType.post,
    );

    emit(
      state.copyWith(
        isLiked: isLiked,
        likeCount: state.post.likeCount,
      ),
    );
  }

  void togglePostLike() {
    if (state.isLiked) {
      databaseRepository.deleteLike(
        currentUser.id,
        state.post.id,
        EntityType.post,
      );
      emit(
        state.copyWith(
          isLiked: false,
          likeCount: state.likeCount - 1,
        ),
      );
    } else {
      databaseRepository.addLike(
        currentUser.id,
        state.post.id,
        EntityType.post,
      );
      emit(
        state.copyWith(
          isLiked: true,
          likeCount: state.likeCount + 1,
        ),
      );
    }
  }

  void deleteLoop() {
    databaseRepository.deletePost(post);
  }
}
