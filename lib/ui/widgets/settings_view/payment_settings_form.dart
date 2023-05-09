import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/settings_view/connect_bank_button.dart';
import 'package:intheloopapp/ui/widgets/settings_view/services_list.dart';

class PaymentSettingsForm extends StatelessWidget {
  const PaymentSettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const ConnectBankButton(),
            const SizedBox(height: 20),
            const ServicesList(),
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
  }
}
