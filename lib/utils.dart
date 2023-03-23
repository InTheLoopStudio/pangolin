import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:georange/georange.dart';
import 'package:intl/intl.dart';

final georange = GeoRange();

const latPerMile = 0.0144927536231884; // degrees latitude per mile
const lngPerMile = 0.0181818181818182; // degrees longitude per mile

/// project extensions for firebase's `DocumentSnapshot<T>` class
extension DefaultValue<V> on DocumentSnapshot<Map<String, dynamic>> {
  /// helper function to try an index the `DocumentSnapshot<T>` object
  /// and return a custom default value if the desired index doesn't exist
  ///
  /// This is useful for adding new fields to DB models since it means
  /// a custom migration script doesn't need to be made every time
  /// and can instead just set its default client-side
  V getOrElse(String key, V defaultValue) {
    if (data() != null && data()!.containsKey(key)) {
      return (data()![key] ?? defaultValue) as V;
    } else {
      return defaultValue;
    }
  }
}

/// helper function to format `DateTime` objects
String formatDate(DateTime date) {
  final dateFormat = DateFormat.yMd().add_jm();

  return dateFormat.format(date);
}

/// helper function to format `DateTime` objects into string
/// specifically for `DateTime`s that are within 7 days of
/// `DateTime.now()`
String formatDateSameWeek(DateTime date) {
  DateFormat dateFormat;

  if (date.day == DateTime.now().day) {
    dateFormat = DateFormat('hh:mm a');
  } else {
    dateFormat = DateFormat('EEEE, hh:mm a');
  }

  return dateFormat.format(date);
}

/// helper function to format `DateTime` objects into strings
String formatDateMessage(DateTime date) {
  final dateFormat = DateFormat('EEE. MMM. d ' 'yy' ' hh:mm a');

  return dateFormat.format(date);
}

/// helper function to determine if a given
/// timestamp is within a week of `DateTime.now()`
bool isSameWeek(DateTime timestamp) {
  return DateTime.now().difference(timestamp).inDays < 7;
}

String geocodeEncode({
  required double lat,
  required double lng,
}) {
  return georange.encode(lng, lat);
}

LatLng geocodeDecode(String geohash) {
  final decoded = georange.decode(geohash);
  return LatLng(
    lng: decoded.longitude,
    lat: decoded.latitude,
  );
}

// Get the geohash upper & lower bounds
GeoHashRange getGeohashRange({
  required double latitude,
  required double longitude,
  int distance = 12, // miles
}) {
  final lowerLat = latitude - latPerMile * distance;
  final lowerLon = longitude - lngPerMile * distance;

  final upperLat = latitude + latPerMile * distance;
  final upperLon = longitude + lngPerMile * distance;

  final lower = georange.encode(lowerLat, lowerLon);
  final upper = georange.encode(upperLat, upperLon);

  return GeoHashRange(lower: lower, upper: upper);
}

double geoDistance(Point p1, Point p2) {
  return georange.distance(p1, p2);
}

class GeoHashRange {
  GeoHashRange({
    required this.upper,
    required this.lower,
  });

  final String upper;
  final String lower;
}

String formattedAddress(List<AddressComponent>? shortNames) =>
    shortNames?.first.shortName ?? 'Location';
