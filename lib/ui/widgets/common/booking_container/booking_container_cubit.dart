import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/booking.dart';

part 'booking_container_state.dart';

class BookingContainerCubit extends Cubit<BookingContainerState> {
  BookingContainerCubit({
    required this.booking,
  }) : super(BookingContainerState(booking: booking));

  final Booking booking;
}
