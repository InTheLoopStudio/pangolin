import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    });
    on<ConfirmBooking>((event, emit) {
      emit(const BookingsState());
    });
    on<DenyBooking>((event, emit) {
      emit(const BookingsState());
    });
  }

  final AuthenticationBloc authenticationBloc;
  final DatabaseRepository database;
}
