import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit({
    required this.currentUserId,
    required this.accountType,
    required this.databaseRepository,
  }) : super(const BookingsState());

  final String currentUserId;
  final AccountType accountType;
  final DatabaseRepository databaseRepository;

  Future<void> initBookings() async {
    final bookings = accountType == AccountType.venue
        ? await databaseRepository.getBookingsByRequester(currentUserId)
        : await databaseRepository.getBookingsByRequestee(currentUserId);

    emit(
      state.copyWith(
        bookings: bookings,
      ),
    );
  }

  void onConfirm(Booking booking) {
    final index =
        state.bookings.indexWhere((element) => element.id == booking.id);
    final tmpList = state.bookings;
    tmpList[index] = booking;

    emit(state.copyWith(bookings: tmpList));
  }

  void onDeny(Booking booking) {
    final index =
        state.bookings.indexWhere((element) => element.id == booking.id);
    final tmpList = state.bookings;
    tmpList[index] = booking;

    emit(state.copyWith(bookings: tmpList));
  }
}
