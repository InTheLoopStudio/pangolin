part of 'new_chat_cubit.dart';

class NewChatState extends Equatable {
  NewChatState({
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

  NewChatState copyWith({
    List<UserModel>? searchResults,
    String? searchTerm,
    bool? loading,
  }) {
    return NewChatState(
      searchResults: searchResults ?? this.searchResults,
      searchTerm: searchTerm ?? this.searchTerm,
      loading: loading ?? this.loading,
      textController: this.textController,
    );
  }
}
