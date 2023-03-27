import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/payment_repository.dart';
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
                state.visitedUser.isNotVenue &&
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
                            ),
                          );
                        }
                      : null,
                  child: state.visitedUser.stripeConnectedAccountId.isNotEmpty
                      ? const Text('Request to Book')
                      : const Text('Payment Info not Connected'),
                ),
              )
            : const SizedBox(
                height: 2,
              );
      },
    );
  }
}
