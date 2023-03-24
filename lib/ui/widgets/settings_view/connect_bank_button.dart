import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/domains/models/payment_user.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectBankButton extends StatelessWidget {
  const ConnectBankButton({super.key});

  Widget _connectBankAccountButton({
    required PaymentRepository payments,
  }) =>
      CupertinoButton.filled(
        child: const Text('Connect Bank Account'),
        onPressed: () async {
          // create connected account
          final res = await payments.createConnectedAccount();

          if (res.success != true) {
            // show error
          }

          await launchUrl(
            Uri.parse(res.url),
            mode: LaunchMode.externalApplication,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final payments = RepositoryProvider.of<PaymentRepository>(context);
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, state) {
        final currentUser = state.currentUser;
        if (currentUser.stripeConnectedAccountId.isEmpty) {
          return _connectBankAccountButton(
            payments: payments,
          );
        }

        return FutureBuilder<PaymentUser?>(
          future: payments.getAccountById(currentUser.stripeConnectedAccountId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final paymentUser = snapshot.data;

            if (paymentUser == null) {
              return _connectBankAccountButton(
                payments: payments,
              );
            }

            if (!paymentUser.payoutsEnabled) {
              return _connectBankAccountButton(
                payments: payments,
              );
            }

            return const CupertinoButton(
              onPressed: null,
              child: Text('Bank Account Connected'),
            );
          },
        );
      },
    );
  }
}
