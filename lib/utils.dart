import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DefaultValue<K, V> on DocumentSnapshot<Map<String, dynamic>> {
  V getOrElse(K key, V defaultValue) {
    if (data() != null && data()!.containsKey(key)) {
      return data()![key] ?? defaultValue;
    } else {
      return defaultValue;
    }
  }
}

String formatDate(DateTime date) {
  final dateFormat = DateFormat.yMd().add_jm();

  return dateFormat.format(date);
}

String formatDateSameWeek(DateTime date) {
  DateFormat dateFormat;

  if (date.day == DateTime.now().day) {
    dateFormat = DateFormat('hh:mm a');
  } else {
    dateFormat = DateFormat('EEEE, hh:mm a');
  }

  return dateFormat.format(date);
}

String formatDateMessage(DateTime date) {
  final dateFormat = DateFormat('EEE. MMM. d ' 'yy' ' hh:mm a');

  return dateFormat.format(date);
}

bool isSameWeek(DateTime timestamp) {
  return DateTime.now().difference(timestamp).inDays < 7;
}
