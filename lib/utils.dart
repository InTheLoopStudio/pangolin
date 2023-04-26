import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:georange/georange.dart';
import 'package:intl/intl.dart';

const undefined = '__undefined__';

final georange = GeoRange();

const latPerKm = 0.009090909090909; // degrees latitude per Km
const lngPerKm = 0.0089847259658580; // degrees longitude per Km

/// project extensions for firebase's `DocumentSnapshot<T>` class
extension DefaultValue<V> on DocumentSnapshot<Map<String, dynamic>> {
  /// helper function to try an index the `DocumentSnapshot<T>` object
  /// and return a custom default value if the desired index doesn't exist
  ///
  /// This is useful for adding new fields to DB models since it means
  /// a custom migration script doesn't need to be made every time
  /// and can instead just set its default client-side
  V getOrElse(String key, V defaultValue) {
    final data = this.data();

    return data != null && data.containsKey(key)
        ? (data[key] ?? defaultValue) as V
        : defaultValue;
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

  dateFormat = date.day == DateTime.now().day
      ? DateFormat('hh:mm a')
      : DateFormat('EEEE, hh:mm a');

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
  return georange.encode(lat, lng);
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
  int distance = 100, // Km
}) {
  final lowerLat = latitude - latPerKm * distance;
  final lowerLon = longitude - lngPerKm * distance;

  final upperLat = latitude + latPerKm * distance;
  final upperLon = longitude + lngPerKm * distance;

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
    shortNames?.first.shortName ?? 'Unknown';

@immutable
class Option<T> {
  const Option(this.value);

  final T? value;

  bool get isSome => value != null;

  bool get isNone => value == null;

  T get unwrap => value!;

  T unwrapOr(T defaultValue) => value ?? defaultValue;

  T unwrapOrElse(T Function() f) => value ?? f();

  Option<R> map<R>(R Function(T) f) =>
      isSome ? Option(f(unwrap)) : const Option(null);

  Option<R> flatMap<R>(Option<R> Function(T) f) =>
      isSome ? f(unwrap) : const Option(null);

  Option<T> filter(bool Function(T) f) =>
      isSome && f(unwrap) ? this : const Option(null);

  Option<T> or(Option<T> other) => isSome ? this : other;

  Option<T> orElse(Option<T> Function() f) => isSome ? this : f();

  Option<T> and(Option<T> other) =>
      isSome && other.isSome ? this : const Option(null);

  Option<T> andThen(Option<T> Function() f) =>
      isSome ? f() : const Option(null);

  Option<T> xor(Option<T> other) =>
      isSome ^ other.isSome ? this : const Option(null);

  Option<T> not() => isSome ? const Option(null) : this;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Option &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Option{value: $value}';
}
