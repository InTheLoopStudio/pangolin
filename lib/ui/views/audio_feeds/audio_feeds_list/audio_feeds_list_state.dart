part of 'audio_feeds_list_cubit.dart';

@immutable
class AudioFeedsListState extends Equatable {
  AudioFeedsListState({PageController? pageController, this.currentIndex = 1}) {
    this.pageController = pageController ?? PageController(initialPage: 1);
  }

  final int currentIndex;
  late final PageController pageController;

  @override
  List<Object> get props => [currentIndex, pageController];

  AudioFeedsListState copyWith({
    int? currentIndex,
    PageController? pageController,
  }) {
    return AudioFeedsListState(
      currentIndex: currentIndex ?? this.currentIndex,
      pageController: pageController ?? this.pageController,
    );
  }
}
