part of 'loop_view_cubit.dart';

@immutable
class LoopViewState extends Equatable {
  const LoopViewState({
    required this.loop,
    required this.user,
    this.audioController,
    this.showComments = false,
    this.loadingLoop = false,
    this.feedId,
    this.isFollowing = false,
    this.isLiked = false,
    this.isVerified = false,
    this.likeCount = 0,
    this.commentsCount = 0,
  });

  final Loop loop;
  final UserModel user;
  final bool showComments;
  final String? feedId;
  final bool loadingLoop;
  final bool isFollowing;
  final bool isLiked;
  final bool isVerified;
  final int commentsCount;
  final int likeCount;

  final AudioController? audioController;

  @override
  List<Object> get props => [
        loop,
        showComments,
        loadingLoop,
        isFollowing,
        isLiked,
        isVerified,
        commentsCount,
        likeCount,
      ];

  LoopViewState copyWith({
    Loop? loop,
    UserModel? user,
    bool? showComments,
    String? feedId,
    bool? loading,
    bool? isFollowing,
    bool? isLiked,
    bool? isVerified,
    int? commentsCount,
    int? likeCount,
    AudioController? audioController,
  }) {
    return LoopViewState(
      audioController: audioController ?? this.audioController,
      loop: loop ?? this.loop,
      user: user ?? this.user,
      feedId: feedId ?? this.feedId,
      showComments: showComments ?? this.showComments,
      loadingLoop: loading ?? loadingLoop,
      isFollowing: isFollowing ?? this.isFollowing,
      isLiked: isLiked ?? this.isLiked,
      isVerified: isVerified ?? this.isVerified,
      commentsCount: commentsCount ?? this.commentsCount,
      likeCount: likeCount ?? this.likeCount,
    );
  }
}
