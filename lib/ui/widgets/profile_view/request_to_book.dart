import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/domains/models/payment_user.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

class RequestToBookButton extends StatelessWidget {
  const RequestToBookButton({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final payments = context.read<PaymentRepository>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return (state.currentUser.id != state.visitedUser.id &&
                state.currentUser.isVenue)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: FutureBuilder<PaymentUser?>(
                  future: () async {
                    if (state.visitedUser.stripeConnectedAccountId == null) {
                      return null;
                    }

                    return payments.getAccountById(
                      state.visitedUser.stripeConnectedAccountId!,
                    );
                  }(),
                  builder: (context, snapshot) {
                    final paymentUser = snapshot.data;

                    final enabled =
                        paymentUser != null && paymentUser.payoutsEnabled;

                    return FilledButton(
                      onPressed: enabled
                          ? () {
                              navigationBloc.add(
                                PushCreateBooking(
                                  requesteeId: state.visitedUser.id,
                                  requesteeStripeConnectedAccountId: state
                                      .visitedUser.stripeConnectedAccountId!,
                                  requesteeBookingRate:
                                      state.visitedUser.bookingRate,
                                ),
                              );
                            }
                          : null,
                      child: !enabled
                          ? const Text('Artist Payment Info not Connected')
                          : const Text('Request to Book'),
                    );
                  },
                ),
              )
            : const SizedBox(
                height: 2,
              );
      },
    );
  }
}
