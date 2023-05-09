import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

                  final service = state.services[index - 1];

                  return badges.Badge(
                    onTap: () {
                      try {
                        context.read<SettingsCubit>().removeService(
                              service,
                            );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error removing service'),
                          ),
                        );
                      }
                    },
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Color.fromARGB(255, 47, 47, 47),
                    ),
                    badgeContent: const Icon(
                      Icons.close_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    child: ServiceCard(
                      service: service,
                    ),
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
