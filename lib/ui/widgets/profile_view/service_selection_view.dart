import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/common/tapped_app_bar.dart';
import 'package:skeletons/skeletons.dart';

class ServiceSelectionView extends StatelessWidget {
  const ServiceSelectionView({
    required this.userId,
    required this.requesteeStripeConnectedAccountId,
    super.key,
  });

  final String userId;
  final String requesteeStripeConnectedAccountId;

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const TappedAppBar(
        title: 'Select Service',
      ),
      body: FutureBuilder<List<Service>>(
        future: context.read<DatabaseRepository>().getUserServices(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SkeletonListView();
          }

          final services = snapshot.data!;

          if (services.isEmpty) {
            return const Center(
              child: EasterEggPlaceholder(
                text: 'No services found',
              ),
            );
          }

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];

              return ListTile(
                leading: const Icon(Icons.work),
                title: Text(service.title),
                subtitle: Text(service.description),
                trailing: Text(
                  // ignore: lines_longer_than_80_chars
                  '\$${(service.rate / 100).toStringAsFixed(2)}${service.rateType == RateType.hourly ? '/hr' : ''}',
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
                onTap: () {
                  navigationBloc.add(
                    PushCreateBooking(
                      service: service,
                      requesteeStripeConnectedAccountId:
                          requesteeStripeConnectedAccountId,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
