part of 'bookings_cubit.dart';

class BookingsState extends Equatable {
  const BookingsState({
    this.bookings = const [],
  });

  final List<Booking> bookings;

  @override
  List<Object> get props => [bookings];

  BookingsState copyWith({
    List<Booking>? bookings,
  }) {
    return BookingsState(
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
