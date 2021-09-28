part of 'loop_view_cubit.dart';

@immutable
class LoopViewState extends Equatable {
  LoopViewState({
    AudioController? audioController,
    required this.loop,
    required this.user,
    this.showComments = false,
    this.loadingLoop = false,
    this.feedId,
    this.isFollowing = false,
    this.isLiked = false,
    this.likesCount = 0,
    this.commentsCount = 0,
  }) {
    this.audioController = audioController ?? AudioController();
  }

  final Loop loop;
  final UserModel user;
  final bool showComments;
  final String? feedId;
  final bool loadingLoop;
  final bool isFollowing;
  final bool isLiked;
  final int commentsCount;
  final int likesCount;

  late final AudioController audioController;

  @override
  List<Object> get props => [
        loop,
        showComments,
        loadingLoop,
        isFollowing,
        isLiked,
        commentsCount,
        likesCount,
      ];

  LoopViewState copyWith({
    Loop? loop,
    UserModel? user,
    bool? showComments,
    String? feedId,
    bool? loading,
    bool? isFollowing,
    bool? isLiked,
    int? commentsCount,
    int? likesCount,
  }) {
    return LoopViewState(
      audioController: this.audioController,
      loop: loop ?? this.loop,
      user: user ?? this.user,
      feedId: feedId ?? this.feedId,
      showComments: showComments ?? this.showComments,
      loadingLoop: loading ?? this.loadingLoop,
      isFollowing: isFollowing ?? this.isFollowing,
      isLiked: isLiked ?? this.isLiked,
      commentsCount: commentsCount ?? this.commentsCount,
      likesCount: likesCount ?? this.likesCount,
    );
  }
}
