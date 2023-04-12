import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';

class Review extends Equatable {
  const Review({
    required this.bookingId,
    required this.reviewerId,
    required this.revieweeId,
  });

  factory Review.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Review(
      bookingId: doc.getOrElse('bookingId', '') as String,
      reviewerId: doc.getOrElse('reviewerId', '') as String,
      revieweeId: doc.getOrElse('revieweeId', '') as String,
    );
  }

  final String bookingId;
  final String reviewerId;
  final String revieweeId;

  @override
  List<Object> get props => [
        bookingId,
        reviewerId,
        revieweeId,
      ];

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
    };
  }
}
