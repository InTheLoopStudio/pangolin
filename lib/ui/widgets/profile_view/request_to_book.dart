import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/domains/models/payment_user.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';

class RequestToBookButton extends StatelessWidget {
  const RequestToBookButton({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final payments = context.read<PaymentRepository>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return (state.currentUser.id != state.visitedUser.id)
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

                    if (!enabled) {
                      return const FilledButton(
                        onPressed: null,
                        child: Text('Artist Payment Info not Connected'),
                      );
                    }

                    return FilledButton(
                      onPressed: () {
                        navigationBloc.add(
                          PushServiceSelection(
                            userId: state.visitedUser.id,
                            requesteeStripeConnectedAccountId:
                                state.visitedUser.stripeConnectedAccountId!,
                          ),
                        );
                      },
                      child: const Text('Request to Book'),
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
