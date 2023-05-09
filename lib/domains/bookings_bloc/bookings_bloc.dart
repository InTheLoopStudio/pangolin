import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/booking.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  BookingsBloc({
    required this.authenticationBloc,
    required this.database,
  }) : super(const BookingsState()) {
    on<BookingsInitial>((event, emit) {
      emit(const BookingsState());
    });
    on<FetchBookings>((event, emit) async {
      try {
        final currentUserId =
            (authenticationBloc.state as Authenticated).currentAuthUser.uid;

        final requesterBookings =
            await database.getBookingsByRequester(currentUserId);

        final requesteeBookings =
            await database.getBookingsByRequestee(currentUserId);

        final bookings = requesteeBookings..addAll(requesterBookings);

        emit(
          BookingsState(
            bookings: bookings,
          ),
        );
      } catch (e, s) {
        logger.error(
          'Error fetching bookings',
          error: e,
          stackTrace: s,
        );
      }
    });
    on<ConfirmBooking>((event, emit) async {
      try {
        final newBooking = event.booking.copyWith(
          status: BookingStatus.confirmed,
        );
        final newBookings = state.bookings;
        newBookings[newBookings.indexOf(event.booking)] = newBooking;
        await database.updateBooking(newBooking);
        emit(
          BookingsState(
            bookings: newBookings,
          ),
        );
      } catch (e, s) {
        logger.error(
          'error confirming booking',
          error: e,
          stackTrace: s,
        );
      }
    });
    on<DenyBooking>((event, emit) async {
      try {
        final newBooking = event.booking.copyWith(
          status: BookingStatus.canceled,
        );
        state.bookings[state.bookings.indexOf(event.booking)] = newBooking;
        final newBookings = state.bookings;
        newBookings[newBookings.indexOf(event.booking)] = newBooking;
        await database.updateBooking(newBooking);
        emit(
          BookingsState(
            bookings: newBookings,
          ),
        );
      } catch (e, s) {
        logger.error(
          'error denying booking',
          error: e,
          stackTrace: s,
        );
      }
    });
  }

  final AuthenticationBloc authenticationBloc;
  final DatabaseRepository database;
}
