part of 'search_cubit.dart';

class SearchState extends Equatable {
  SearchState({
    required this.tabController,
    this.searchResults = const [],
    this.searchResultsByLocation = const [],
    this.locationResults = const [],
    this.loopSearchResults = const [],
    this.searchTerm = '',
    this.lastRememberedSearchTerm = '',
    this.loading = false,
    TextEditingController? textController,
  }) {
    this.textController = textController ?? TextEditingController();
  }

  final List<UserModel> searchResults;
  final List<Loop> loopSearchResults;
  final List<UserModel> searchResultsByLocation;
  final List<AutocompletePrediction> locationResults;
  final String searchTerm;
  final String lastRememberedSearchTerm;
  late final TextEditingController textController;
  late final TabController tabController;
  final bool loading;

  @override
  List<Object> get props => [
        tabController,
        searchResults,
        searchResultsByLocation,
        locationResults,
        loopSearchResults,
        searchTerm,
        lastRememberedSearchTerm,
        loading,
      ];

  SearchState copyWith({
    List<UserModel>? searchResults,
    List<Loop>? loopSearchResults,
    List<UserModel>? searchResultsByLocation,
    List<AutocompletePrediction>? locationResults,
    String? searchTerm,
    String? lastRememberedSearchTerm,
    bool? loading,
  }) {
    return SearchState(
      tabController: tabController,
      locationResults: locationResults ?? this.locationResults,
      loopSearchResults: loopSearchResults ?? this.loopSearchResults,
      searchResults: searchResults ?? this.searchResults,
      searchResultsByLocation:
          searchResultsByLocation ?? this.searchResultsByLocation,
      searchTerm: searchTerm ?? this.searchTerm,
      lastRememberedSearchTerm:
          lastRememberedSearchTerm ?? this.lastRememberedSearchTerm,
      loading: loading ?? this.loading,
      textController: textController,
    );
  }
}
