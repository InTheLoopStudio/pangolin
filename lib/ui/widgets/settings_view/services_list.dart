import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/settings_view/create_service_button.dart';
import 'package:intheloopapp/ui/widgets/settings_view/service_card.dart';

class ServicesList extends StatelessWidget {
  const ServicesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text('Services Offered (edit)'),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.services.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const CreateServiceButton();
                  }

                  return ServiceCard(
                    service: state.services[index-1],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
