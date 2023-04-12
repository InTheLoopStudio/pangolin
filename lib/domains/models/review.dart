import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.bookingId,
    required this.reviewerId,
    required this.revieweeId,
  });

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
