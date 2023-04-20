part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object> get props => [];
}

class BookingsInitial extends BookingsEvent {}

class FetchBookings extends BookingsEvent {}

class ConfirmBooking extends BookingsEvent {
  const ConfirmBooking({required this.booking});

  final Booking booking;

  @override
  List<Object> get props => [booking];
}

class DenyBooking extends BookingsEvent {
  const DenyBooking({required this.booking});

  final Booking booking;

  @override
  List<Object> get props => [booking];
}
