import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/places_repository.dart';

const _placesKey = 'AIzaSyAh3GEqDEv4lfnAgeT19-7sgyF7JxLF34g';
final _places = FlutterGooglePlacesSdk(_placesKey);

class GooglePlacesImpl implements PlacesRepository {
  @override
  Future<Place?> getPlaceById(String placeId) async {

    if (placeId.isEmpty) return null;

    try {
      final result = await _places.fetchPlace(
        placeId,
        fields: [
          PlaceField.Id,
          PlaceField.AddressComponents,
          PlaceField.Location,
        ],
      );

      return result.place;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<AutocompletePrediction>> searchPlace(String query) async {
    try {
      final predictions = await _places.findAutocompletePredictions(query);
      return predictions.predictions;
    } on Exception {
      return [];
    }
  }
}
