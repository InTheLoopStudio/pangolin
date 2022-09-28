part of 'search_cubit.dart';

class SearchState extends Equatable {
  SearchState({
    this.searchResults = const [],
    this.searchTerm = '',
    this.loading = false,
    TextEditingController? textController,
  }) {
    this.textController = textController ?? TextEditingController();
  }

  final List<UserModel> searchResults;
  final String searchTerm;
  late final TextEditingController textController;
  final bool loading;

  @override
  List<Object> get props => [
        searchResults,
        searchTerm,
        loading,
      ];

  SearchState copyWith({
    List<UserModel>? searchResults,
    String? searchTerm,
    bool? loading,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      searchTerm: searchTerm ?? this.searchTerm,
      loading: loading ?? this.loading,
      textController: textController,
    );
  }
}
