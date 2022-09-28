part of 'comments_cubit.dart';

@immutable
class CommentsState extends Equatable {
  const CommentsState({
    required this.loop,
    this.comments = const [],
    this.commentsCount = 0,
    this.loading = false,
    this.comment = '',
  });

  final Loop loop;
  final List<Comment> comments;
  final int commentsCount;
  final bool loading;
  final String comment;

  @override
  List<Object> get props => [
        loop,
        comments,
        commentsCount,
        loading,
        comment,
      ];

  CommentsState copyWith({
    Loop? loop,
    List<Comment>? comments,
    int? commentsCount,
    bool? loading,
    String? comment,
  }) {
    return CommentsState(
      loop: loop ?? this.loop,
      comments: comments ?? this.comments,
      commentsCount: commentsCount ?? this.commentsCount,
      loading: loading ?? this.loading,
      comment: comment ?? this.comment,
    );
  }
}
