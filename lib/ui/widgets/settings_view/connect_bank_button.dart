import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/domains/models/payment_user.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectBankButton extends StatefulWidget {
  const ConnectBankButton({super.key});

  @override
  State<ConnectBankButton> createState() => _ConnectBankButtonState();
}

class _ConnectBankButtonState extends State<ConnectBankButton> {
  bool loading = false;

  Widget _connectBankAccountButton({
    required PaymentRepository payments,
    required UserModel currentUser,
    required OnboardingBloc onboardingBloc,
  }) =>
      CupertinoButton.filled(
        child: loading
            ? const CircularProgressIndicator(
              color: Colors.white,
            )
            : const Text('Connect Bank Account'),
        onPressed: () async {
          if (loading) {
            return;
          }

          setState(() {
            loading = true;
          });

          // create connected account
          final res = await payments.createConnectedAccount();

          if (res.success != true) {
            // show error
          }

          final updatedUser = currentUser.copyWith(
            stripeConnectedAccountId: res.accountId,
          );

          onboardingBloc.add(
            UpdateOnboardedUser(
              user: updatedUser,
            ),
          );

          await launchUrl(
            Uri.parse(res.url),
            mode: LaunchMode.externalApplication,
          );

          setState(() {
            loading = false;
          });
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
            currentUser: currentUser,
            onboardingBloc: context.read<OnboardingBloc>(),
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
                currentUser: currentUser,
                onboardingBloc: context.read<OnboardingBloc>(),
              );
            }

            if (!paymentUser.payoutsEnabled) {
              return _connectBankAccountButton(
                payments: payments,
                currentUser: currentUser,
                onboardingBloc: context.read<OnboardingBloc>(),
              );
            }

            return const CupertinoButton(
              onPressed: null,
              child: Text('✅ Bank Account Connected'),
            );
          },
        );
      },
    );
  }
}
