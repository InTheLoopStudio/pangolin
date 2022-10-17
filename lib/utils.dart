import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// project extensions for firebase's `DocumentSnapshot<T>` class
extension DefaultValue<K, V> on DocumentSnapshot<Map<String, dynamic>> {
  /// helper function to try an index the `DocumentSnapshot<T>` object
  /// and return a custom default value if the desired index doesn't exist
  ///
  /// This is useful for adding new fields to DB models since it means
  /// a custom migration script doesn't need to be made every time
  /// and can instead just set its default client-side
  V getOrElse(K key, V defaultValue) {
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
