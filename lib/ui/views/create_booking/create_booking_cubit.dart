import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/booking_end_time.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/booking_name.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/booking_note.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/booking_start_time.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'create_booking_state.dart';

class CreateBookingCubit extends Cubit<CreateBookingState> {
  CreateBookingCubit({
    required this.currentUser,
    required this.requesteeId,
    required this.requesteeStripeConnectedAccountId,
    required this.requesteeBookingRate,
    required this.navigationBloc,
    required this.onboardingBloc,
    required this.database,
    required this.streamRepo,
    required this.payments,
    required this.bookingFee,
  }) : super(
          CreateBookingState(
            currentUserId: currentUser.id,
            requesteeId: requesteeId,
            requesteeBookingRate: requesteeBookingRate,
            bookingFee: bookingFee,
          ),
        );

  final UserModel currentUser;
  final String requesteeId;
  final String requesteeStripeConnectedAccountId;
  final int requesteeBookingRate;
  final double bookingFee;
  final NavigationBloc navigationBloc;
  final OnboardingBloc onboardingBloc;
  final DatabaseRepository database;
  final StreamRepository streamRepo;
  final PaymentRepository payments;

  void updateStartTime(DateTime value) => emit(
        state.copyWith(
          startTime: BookingStartTime.dirty(value),
          endTime: value.isAfter(state.endTime.value)
              ? BookingEndTime.dirty(value)
              : state.endTime,
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

  Future<void> createBooking() async {
    final booking = Booking(
      id: const Uuid().v4(),
      name: state.name.value,
      note: state.note.value,
      requesterId: state.currentUserId,
      requesteeId: state.requesteeId,
      rate: state.requesteeBookingRate,
      status: BookingStatus.pending,
      startTime: state.startTime.value,
      endTime: state.endTime.value,
      timestamp: DateTime.now(),
    );
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final total = state.totalCost;

    try {
      if (total > 0) {
        final intent = await payments.initPaymentSheet(
          payerCustomerId: currentUser.stripeCustomerId,
          payeeConnectedAccountId: requesteeStripeConnectedAccountId,
          amount: total,
        );

        if (intent.customer != currentUser.stripeCustomerId) {
          onboardingBloc.add(
            UpdateOnboardedUser(
              user: currentUser.copyWith(
                stripeCustomerId: intent.customer,
              ),
            ),
          );
        }

        await payments.presentPaymentSheet();

        await payments.confirmPaymentSheetPayment();
      }

      final channel = await streamRepo.createSimpleChat(state.requesteeId);
      await channel.sendMessage(
        Message(
          text: state.note.value,
        ),
      );
      await database.createBooking(booking);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      navigationBloc.add(const Pop());
    } on Exception {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      rethrow;
    }
  }
}
