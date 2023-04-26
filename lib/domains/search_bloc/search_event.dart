part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class ChangeSearchTab extends SearchEvent {
  const ChangeSearchTab({required this.index});

  final int index;
}

class Search extends SearchEvent {
  const Search({required this.query});

  final String query;
}

class SearchUsersByPrediction extends SearchEvent {
  const SearchUsersByPrediction({
    required this.prediction,
  });

  final AutocompletePrediction prediction;
}

class SetAdvancedSearchFilters extends SearchEvent {
  const SetAdvancedSearchFilters({
    this.occupations,
    this.genres,
    this.labels,
    this.place,
    this.placeId,
  });

  final List<String>? occupations;
  final List<Genre>? genres;
  final List<String>? labels;
  final Place? place;
  final String? placeId;
}
