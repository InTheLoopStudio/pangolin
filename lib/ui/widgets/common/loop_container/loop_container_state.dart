part of 'loop_container_cubit.dart';

@immutable
class LoopContainerState extends Equatable {
  const LoopContainerState({
    required this.loop,
    this.audioController,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isVerified = false,
  });

  final AudioController? audioController;
  final Loop loop;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isVerified;

  @override
  List<Object?> get props => [
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
    AudioController? audioController,
  }) {
    return LoopContainerState(
      loop: loop ?? this.loop,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isVerified: isVerified ?? this.isVerified,
      audioController: audioController ?? this.audioController,
    );
  }
}
