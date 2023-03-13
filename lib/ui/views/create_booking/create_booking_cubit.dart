import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/booking_end_time.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/booking_name.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/booking_note.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/booking_start_time.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'create_booking_state.dart';

class CreateBookingCubit extends Cubit<CreateBookingState> {
  CreateBookingCubit({
    required this.currentUserId,
    required this.requesteeId,
    required this.navigationBloc,
    required this.database,
  }) : super(
          CreateBookingState(
            currentUserId: currentUserId,
            requesteeId: requesteeId,
          ),
        );

  final String currentUserId;
  final String requesteeId;
  final NavigationBloc navigationBloc;
  final DatabaseRepository database;

  void updateStartTime(DateTime value) => emit(
        state.copyWith(
          startTime: BookingStartTime.dirty(value),
        ),
      );

  void updateEndTime(DateTime value) => emit(
        state.copyWith(
          endTime: BookingEndTime.dirty(value),
        ),
      );

  void updateName(String value) => emit(
        state.copyWith(
          name: BookingName.dirty(value),
        ),
      );

  void updateNote(String value) => emit(
        state.copyWith(
          note: BookingNote.dirty(value),
        ),
      );

  Future<UserModel?> requesteeInfo() async {
    final requestee = await database.getUserById(state.requesteeId);
    return requestee;
  }

  Future<void> createBooking() async {
    final booking = Booking(
      id: const Uuid().v4(),
      name: state.name.value,
      note: state.note.value,
      requesterId: state.currentUserId,
      requesteeId: state.requesteeId,
      status: BookingStatus.pending,
      startTime: state.startTime.value,
      endTime: state.endTime.value,
      timestamp: DateTime.now(),
    );
    await database.createBooking(booking);
    navigationBloc.add(const Pop());
  }
}
