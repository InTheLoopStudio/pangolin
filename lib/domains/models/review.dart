import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';

class Review extends Equatable {
  const Review({
    required this.bookingId,
    required this.reviewerId,
    required this.revieweeId,
    required this.overallRating,
    required this.fanEngagementRating,
    required this.onTime,
    required this.comments,
  });

  factory Review.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Review(
      bookingId: doc.getOrElse('bookingId', '') as String,
      reviewerId: doc.getOrElse('reviewerId', '') as String,
      revieweeId: doc.getOrElse('revieweeId', '') as String,
      overallRating: doc.getOrElse('overallRating', 0.0) as double,
      fanEngagementRating: doc.getOrElse('fanEngagementRating', 0.0) as double,
      onTime: doc.getOrElse('onTime', true) as bool,
      comments: doc.getOrElse('comments', '') as String,
    );
  }

  final String bookingId;
  final String reviewerId;
  final String revieweeId;
  final double overallRating;
  final double fanEngagementRating;
  final bool onTime;
  final String comments;

  @override
  List<Object> get props => [
        bookingId,
        reviewerId,
        revieweeId,
        overallRating,
        fanEngagementRating,
        onTime,
        comments,
      ];

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
      'overallRating': overallRating,
      'fanEngagementRating': fanEngagementRating,
      'onTime': onTime,
      'comments': comments,
    };
  }
}
