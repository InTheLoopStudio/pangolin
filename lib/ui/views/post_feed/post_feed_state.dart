part of 'post_feed_cubit.dart';

enum PostFeedStatus { initial, success, failure }

@immutable
class PostFeedState extends Equatable {
  const PostFeedState({
    this.currentIndex = 0,
    this.hasReachedMax = false,
    this.status = PostFeedStatus.initial,
    this.posts = const [],
  });

  final int currentIndex;
  final bool hasReachedMax;
  final PostFeedStatus status;
  final List<Post> posts;

  @override
  List<Object> get props => [
        currentIndex,
        hasReachedMax,
        status,
        posts,
      ];

  PostFeedState copyWith({
    int? currentIndex,
    bool? hasReachedMax,
    PostFeedStatus? status,
    List<Post>? posts,
  }) {
    return PostFeedState(
      currentIndex: currentIndex ?? this.currentIndex,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      posts: posts ?? this.posts,
    );
  }
}
