part of 'location_cubit.dart';

class LocationState extends Equatable {
  const LocationState({
    this.loading = false,
    this.query = '',
    this.locationResults = const [],
  });

  final bool loading;
  final String query;
  final List<AutocompletePrediction> locationResults;

  @override
  List<Object> get props => [loading, query, locationResults,];

  LocationState copyWith({
    bool? loading,
    String? query,
    List<AutocompletePrediction>? locationResults,
  }) {
    return LocationState(
      loading: loading ?? this.loading,
      query: query ?? this.query,
      locationResults: locationResults ?? this.locationResults,
    );
  }
}
