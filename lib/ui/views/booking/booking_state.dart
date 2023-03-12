part of 'booking_cubit.dart';

class BookingState extends Equatable {
  const BookingState({
    this.bookings = const [],
  });

  final List<Booking> bookings;

  @override
  List<Object> get props => [bookings];

  BookingState copyWith({
    List<Booking>? bookings,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
    );
  }

  List<Booking> get pendingBookings => bookings
      .where(
        (element) => element.status == BookingStatus.pending,
      )
      .toList();

  List<Booking> get pastBookings => bookings
      .where(
        (element) =>
            (element.status == BookingStatus.confirmed) &&
            (element.bookingDate.isBefore(DateTime.now())),
      )
      .toList();

  List<Booking> get upcomingBookings => bookings
      .where(
        (element) =>
            (element.status == BookingStatus.confirmed) &&
            (element.bookingDate.isAfter(DateTime.now())),
      )
      .toList();

  List<Booking> get canceledBookings => bookings
      .where(
        (element) => element.status == BookingStatus.canceled,
      )
      .toList();
}
