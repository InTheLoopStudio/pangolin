part of 'loop_container_cubit.dart';

@immutable
class LoopContainerState extends Equatable {
  const LoopContainerState({
    required this.loop,
    required this.audioController,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isVerified = false,
  });

  final AudioController audioController;
  final Loop loop;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isVerified;

  @override
  List<Object> get props => [
        loop,
        audioController,
        likeCount,
        commentCount,
        isLiked,
        isVerified,
      ];

  LoopContainerState copyWith({
    Loop? loop,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isVerified,
  }) {
    return LoopContainerState(
      loop: loop ?? this.loop,
      audioController: audioController,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
