import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';

class RequestToBookButton extends StatelessWidget {
  const RequestToBookButton({super.key});

  @override
  Widget build(BuildContext context) {
    final payments = context.read<PaymentRepository>();
    final navigationBloc = context.read<NavigationBloc>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return (state.currentUser.id != state.visitedUser.id &&
                state.visitedUser.isNotVenue &&
                state.currentUser.isVenue)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoButton.filled(
                  onPressed: () async {
                    await payments.initPaymentSheet(
                      payerId: state.currentUser.id,
                      payeeConnectedAccountId:
                          state.currentUser.stripeConnectedAccountId,
                      amount: 100,
                    );
                    await payments.presentPaymentSheet();
                    // navigationBloc.add(PushCreateBooking(state.visitedUser.id));
                  },
                  child: const Text('Request to Book'),
                ),
              )
            : const SizedBox(
                height: 2,
              );
      },
    );
  }
}
