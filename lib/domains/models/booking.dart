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
    required this.name,
    required this.note,
    required this.requesterId,
    required this.requesteeId,
    required this.status,
    required this.rate,
    required this.startTime,
    required this.endTime,
    required this.timestamp,
  });

  factory Booking.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final tmpTimestamp =
        doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
    final tmpStartTime =
        doc.getOrElse('startTime', Timestamp.now()) as Timestamp;
    final tmpEndTime = doc.getOrElse('endTime', Timestamp.now()) as Timestamp;
    return Booking(
      id: doc.id,
      name: doc.getOrElse('name', '') as String,
      note: doc.getOrElse('note', '') as String,
      requesterId: doc.getOrElse('requesterId', '') as String,
      requesteeId: doc.getOrElse('requesteeId', '') as String,
      rate: doc.getOrElse('rate', 0) as int,
      status: EnumToString.fromString(
            BookingStatus.values,
            doc.getOrElse('status', '') as String,
          ) ??
          BookingStatus.pending,
      startTime: tmpStartTime.toDate(),
      endTime: tmpEndTime.toDate(),
      timestamp: tmpTimestamp.toDate(),
    );
  }

  String id;
  String name;
  String note;
  String requesterId;
  String requesteeId;
  BookingStatus status;
  int rate;
  DateTime startTime;
  DateTime endTime;
  DateTime timestamp;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'note': note,
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'rate': rate,
      'status': EnumToString.convertToString(status),
      'timestamp': Timestamp.fromDate(timestamp),
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
    };
  }

  Booking copyWith({
    String? id,
    String? name,
    String? note,
    String? requesterId,
    String? requesteeId,
    int? rate,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? timestamp,
    BookingStatus? status,
  }) {
    return Booking(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      rate: rate ?? this.rate,
      requesterId: requesterId ?? this.requesterId,
      requesteeId: requesteeId ?? this.requesteeId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  bool get isPending => status == BookingStatus.pending;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCancaled => status == BookingStatus.canceled;

  bool get isExpired => endTime.isBefore(DateTime.now());

  Duration get duration => endTime.difference(startTime);


  int get totalCost =>
      ((rate / 60) * duration.inMinutes).toInt();
}
