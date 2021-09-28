part of 'feeds_list_cubit.dart';

@immutable
class FeedsListState extends Equatable {
  FeedsListState({PageController? pageController, this.currentIndex = 1}) {
    this.pageController = pageController ?? PageController(initialPage: 1);
  }

  final int currentIndex;
  late final PageController pageController;

  @override
  List<Object> get props => [currentIndex, pageController];

  FeedsListState copyWith({
    int? currentIndex,
    PageController? pageController,
  }) {
    return FeedsListState(
      currentIndex: currentIndex ?? this.currentIndex,
      pageController: pageController ?? this.pageController,
    );
  }
}
