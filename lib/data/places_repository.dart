import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

abstract class PlacesRepository {
  Future<List<AutocompletePrediction>> searchPlace(String query);
  Future<Place?> getPlaceById(String placeId);
}
