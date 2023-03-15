part of 'search_cubit.dart';

class SearchState extends Equatable {
  SearchState({
    this.searchResults = const [],
    this.searchResultsByLocation = const [],
    this.locationResults = const [],
    this.searchTerm = '',
    this.loading = false,
    TextEditingController? textController,
  }) {
    this.textController = textController ?? TextEditingController();
  }

  final List<UserModel> searchResults;
  final List<UserModel> searchResultsByLocation;
  final List<AutocompletePrediction> locationResults;
  final String searchTerm;
  late final TextEditingController textController;
  final bool loading;

  @override
  List<Object> get props => [
        searchResults,
        searchResultsByLocation,
        locationResults,
        searchTerm,
        loading,
      ];

  SearchState copyWith({
    List<UserModel>? searchResults,
    List<UserModel>? searchResultsByLocation,
    List<AutocompletePrediction>? locationResults,
    String? searchTerm,
    bool? loading,
  }) {
    return SearchState(
      locationResults: locationResults ?? this.locationResults,
      searchResults: searchResults ?? this.searchResults,
      searchResultsByLocation:
          searchResultsByLocation ?? this.searchResultsByLocation,
      searchTerm: searchTerm ?? this.searchTerm,
      loading: loading ?? this.loading,
      textController: textController,
    );
  }
}
