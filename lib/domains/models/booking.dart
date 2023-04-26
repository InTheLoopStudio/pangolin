import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';

enum BookingStatus {
  pending,
  confirmed,
  canceled,
}

class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.name,
    required this.note,
    required this.requesterId,
    required this.requesteeId,
    required this.status,
    required this.rate,
    required this.placeId,
    required this.geohash,
    required this.lat,
    required this.lng,
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
      placeId: doc.getOrElse('placeId', null) as String?,
      geohash: doc.getOrElse('geohash', null) as String?,
      lat: doc.getOrElse('lat', null) as double?,
      lng: doc.getOrElse('lng', null) as double?,
      startTime: tmpStartTime.toDate(),
      endTime: tmpEndTime.toDate(),
      timestamp: tmpTimestamp.toDate(),
    );
  }

  final String id;
  final String name;
  final String note;
  final String requesterId;
  final String requesteeId;
  final BookingStatus status;
  final int rate;

  final String? placeId;
  final String? geohash;
  final double? lat;
  final double? lng;

  final DateTime startTime;
  final DateTime endTime;
  final DateTime timestamp;

  @override
  List<Object?> get props => [
        id,
        name,
        note,
        requesterId,
        requesteeId,
        status,
        rate,
        placeId,
        geohash,
        lat,
        lng,
        startTime,
        endTime,
        timestamp,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'note': note,
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'rate': rate,
      'status': EnumToString.convertToString(status),
      'placeId': placeId,
      'geohash': geohash,
      'lat': lat,
      'lng': lng,
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
    Option<String>? placeId,
    Option<String>? geohash,
    Option<double>? lat,
    Option<double>? lng,
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
      placeId: placeId != null ? placeId.value : this.placeId,
      geohash: geohash != null ? geohash.value : this.geohash,
      lat: lat != null ? lat.value : this.lat,
      lng: lng != null ? lng.value : this.lng,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  bool get isPending => status == BookingStatus.pending;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCancaled => status == BookingStatus.canceled;

  Duration get duration => endTime.difference(startTime);

  int get totalCost => ((rate / 60) * duration.inMinutes).toInt();
}
