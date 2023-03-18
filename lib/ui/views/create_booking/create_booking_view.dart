import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/create_booking/create_booking_cubit.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/create_booking_form.dart';

class CreateBookingView extends StatelessWidget {
  const CreateBookingView({required this.requesteeId, Key? key})
      : super(key: key);

  final String requesteeId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, state) {
        final currentUser = state.currentUser;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: const Row(
              children: [
                Text(
                  'Request to Book',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          body: BlocProvider(
            create: (context) => CreateBookingCubit(
              currentUserId: currentUser.id,
              requesteeId: requesteeId,
              navigationBloc: context.read<NavigationBloc>(),
              database: RepositoryProvider.of<DatabaseRepository>(context),
              streamRepo: RepositoryProvider.of<StreamRepository>(context),
            ),
            child: const CreateBookingForm(),
          ),
        );
      },
    );
  }
}
