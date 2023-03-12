import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intheloopapp/utils.dart';

enum BookingStatus {
  pending,
  confirmed,
  canceled,
}

class Booking {
  Booking({
    required this.id,
    required this.requesterId,
    required this.requesteeId,
    required this.status,
    required this.bookingDate,
    required this.timestamp,
  });

  factory Booking.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final tmpTimestamp =
        doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
    final tmpBookingDate =
        doc.getOrElse('bookingDate', Timestamp.now()) as Timestamp;
    return Booking(
      id: doc.id,
      requesterId: doc.getOrElse('requesterId', '') as String,
      requesteeId: doc.getOrElse('requesteeId', '') as String,
      status: EnumToString.fromString(
            BookingStatus.values,
            doc.getOrElse('status', '') as String,
          ) ??
          BookingStatus.pending,
      bookingDate: tmpBookingDate.toDate(),
      timestamp: tmpTimestamp.toDate(),
    );
  }

  String id;
  String requesterId;
  String requesteeId;
  BookingStatus status;
  DateTime bookingDate;
  DateTime timestamp;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'status': EnumToString.convertToString(status),
      'timestamp': Timestamp.fromDate(timestamp),
      'bookingDate': Timestamp.fromDate(bookingDate),
    };
  }

  Booking copyWith({
    String? id,
    String? requesterId,
    String? requesteeId,
    DateTime? bookingDate,
    DateTime? timestamp,
    BookingStatus? status,
  }) {
    return Booking(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      requesteeId: requesteeId ?? this.requesteeId,
      bookingDate: bookingDate ?? this.bookingDate,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}
