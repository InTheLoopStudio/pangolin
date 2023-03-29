import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';

class RequestToBookButton extends StatelessWidget {
  const RequestToBookButton({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return (state.currentUser.id != state.visitedUser.id &&
                state.currentUser.isVenue)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: FilledButton(
                  onPressed: state
                          .visitedUser.stripeConnectedAccountId.isNotEmpty
                      ? () async {
                          navigationBloc.add(
                            PushCreateBooking(
                              requesteeId: state.visitedUser.id,
                              requesteeStripeConnectedAccountId:
                                  state.visitedUser.stripeConnectedAccountId,
                              requesteeBookingRate:
                                  state.visitedUser.bookingRate,
                            ),
                          );
                        }
                      : null,
                  child: state.visitedUser.stripeConnectedAccountId.isNotEmpty
                      ? const Text('Request to Book')
                      : const Text('Artist Payment Info not Connected'),
                ),
              )
            : const SizedBox(
                height: 2,
              );
      },
    );
  }
}
