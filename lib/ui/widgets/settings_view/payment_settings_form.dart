import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/rate_text_field.dart';
import 'package:intheloopapp/ui/widgets/settings_view/connect_bank_button.dart';

class PaymentSettingsForm extends StatelessWidget {
  const PaymentSettingsForm({super.key});

    @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, userState) {

        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return Column(
              children: [

                // ConnectStripAccountButton(),
                const ConnectBankButton(),
                const SizedBox(height: 20),
                RateTextField(
                  initialValue: state.rate,
                  onChanged: context.read<SettingsCubit>().changeRate,
                ),

                if (state.status.isInProgress)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(tappedAccent),
                  )
                else
                  const SizedBox.shrink(),
              ],
            );
          },
        );
      },
    );
  }
}
