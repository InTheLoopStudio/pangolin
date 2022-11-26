part of 'loop_container_cubit.dart';

@immutable
class LoopContainerState extends Equatable {
  LoopContainerState({
    required this.loop,
    AudioController? audioController,
    this.likeCount = 0,
    this.isLiked = false,
  }) {
    this.audioController = audioController ?? AudioController();
  }

  late final AudioController audioController;
  final Loop loop;
  final int likeCount;
  final bool isLiked;

  @override
  List<Object> get props => [
        loop,
        audioController,
        likeCount,
        isLiked,
      ];

  LoopContainerState copyWith({
    Loop? loop,
    int? likeCount,
    bool? isLiked,
  }) {
    return LoopContainerState(
      loop: loop ?? this.loop,
      audioController: audioController,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
