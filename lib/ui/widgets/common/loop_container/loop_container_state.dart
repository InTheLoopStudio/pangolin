part of 'loop_container_cubit.dart';

@immutable
class LoopContainerState extends Equatable {
  LoopContainerState({
    required this.loop,
    AudioController? audioController,
    this.likesCount = 0,
    this.isLiked = false,
  }) {
    this.audioController = audioController ?? AudioController();
  }

  late final AudioController audioController;
  final Loop loop;
  final int likesCount;
  final bool isLiked;

  @override
  List<Object> get props => [
        loop,
        audioController,
        likesCount,
        isLiked,
      ];

  LoopContainerState copyWith({
    Loop? loop,
    int? likesCount,
    bool? isLiked,
  }) {
    return LoopContainerState(
      loop: loop ?? this.loop,
      audioController: this.audioController,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
