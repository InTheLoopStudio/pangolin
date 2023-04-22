part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    required this.tabIndex,
    this.searchResults = const [],
    this.searchResultsByLocation = const [],
    this.locationResults = const [],
    this.loopSearchResults = const [],
    this.searchTerm = '',
    this.lastRememberedSearchTerm = '',
    this.loading = false,
  });

  final List<UserModel> searchResults;
  final List<Loop> loopSearchResults;
  final List<UserModel> searchResultsByLocation;
  final List<AutocompletePrediction> locationResults;
  final String searchTerm;
  final String lastRememberedSearchTerm;

  final int tabIndex;
  final bool loading;

  @override
  List<Object> get props => [
        tabIndex,
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
    int? tabIndex,
    bool? loading,
  }) {
    return SearchState(
      tabIndex: tabIndex ?? this.tabIndex,
      locationResults: locationResults ?? this.locationResults,
      loopSearchResults: loopSearchResults ?? this.loopSearchResults,
      searchResults: searchResults ?? this.searchResults,
      searchResultsByLocation:
          searchResultsByLocation ?? this.searchResultsByLocation,
      searchTerm: searchTerm ?? this.searchTerm,
      lastRememberedSearchTerm:
          lastRememberedSearchTerm ?? this.lastRememberedSearchTerm,
      loading: loading ?? this.loading,
    );
  }
}
