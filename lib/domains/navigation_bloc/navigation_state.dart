part of 'navigation_bloc.dart';

class NavigationState extends Equatable {
  const NavigationState({this.selectedTab = 0});

  final int selectedTab;

  @override
  String toString() => 'Navigation { selectedTab: $selectedTab }';

  @override
  List<Object> get props => [selectedTab];

  NavigationState copyWith({int? selectedTab}) {
    return NavigationState(
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
