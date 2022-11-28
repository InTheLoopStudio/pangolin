part of 'post_feed_cubit.dart';

enum PostFeedStatus { initial, success, failure }

@immutable
class PostFeedState extends Equatable {
  const PostFeedState({
    this.currentIndex = 0,
    this.hasReachedMax = false,
    this.status = PostFeedStatus.initial,
    this.posts = const [],
    this.easterEggTapped = 0,
  });

  final int currentIndex;
  final bool hasReachedMax;
  final PostFeedStatus status;
  final List<Post> posts;
  final int easterEggTapped;

  @override
  List<Object> get props => [
        currentIndex,
        hasReachedMax,
        status,
        posts,
        easterEggTapped,
      ];

  PostFeedState copyWith({
    int? currentIndex,
    bool? hasReachedMax,
    PostFeedStatus? status,
    List<Post>? posts,
    int? easterEggTapped,
  }) {
    return PostFeedState(
      currentIndex: currentIndex ?? this.currentIndex,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      posts: posts ?? this.posts,
      easterEggTapped: easterEggTapped ?? this.easterEggTapped,
    );
  }
}
