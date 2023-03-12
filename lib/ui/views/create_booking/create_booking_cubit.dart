import 'package:bloc/bloc.dart';

part 'create_booking_state.dart';

class CreateBookingCubit extends Cubit<CreateBookingState> {
  CreateBookingCubit() : super(CreateBookingState());

  Future<void> createBooking() {
    return Future(() => null);
  }
}
