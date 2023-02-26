part of 'post_cubit.dart';

@immutable
class PostState extends Equatable {
  const PostState({
    required this.post,
    this.isVerified = false,
    this.isLiked = false,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  final Post post;
  final bool isVerified;
  final bool isLiked;
  final int likeCount;
  final int commentCount;

  @override
  List<Object> get props => [
        post,
        isVerified,
        likeCount,
        commentCount,
      ];

  PostState copyWith({
    Post? post,
    bool? isVerified,
    bool? isLiked,
    int? likeCount,
    int? commentCount,
  }) {
    return PostState(
      post: post ?? this.post,
      isVerified: isVerified ?? this.isVerified,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}
