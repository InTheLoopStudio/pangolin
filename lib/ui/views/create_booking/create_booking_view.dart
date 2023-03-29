import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/create_booking/create_booking_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/create_booking_form.dart';
import 'package:skeletons/skeletons.dart';

class CreateBookingView extends StatelessWidget {
  const CreateBookingView({
    required this.requesteeId,
    required this.requesteeStripeConnectedAccountId,
    required this.requesteeBookingRate,
    super.key,
  });

  final String requesteeId;
  final String requesteeStripeConnectedAccountId;
  final int requesteeBookingRate;

  @override
  Widget build(BuildContext context) {
    final database = RepositoryProvider.of<DatabaseRepository>(context);
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, state) {
        final currentUser = state.currentUser;
        return BlocProvider(
          create: (context) => CreateBookingCubit(
            currentUser: currentUser,
            requesteeId: requesteeId,
            requesteeStripeConnectedAccountId:
                requesteeStripeConnectedAccountId,
            requesteeBookingRate: requesteeBookingRate,
            navigationBloc: context.read<NavigationBloc>(),
            onboardingBloc: context.read<OnboardingBloc>(),
            database: database,
            streamRepo: RepositoryProvider.of<StreamRepository>(context),
            payments: RepositoryProvider.of<PaymentRepository>(context),
          ),
          child: Scaffold(
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
            floatingActionButton:
                BlocBuilder<CreateBookingCubit, CreateBookingState>(
              builder: (context, state) {
                return FloatingActionButton.extended(
                  onPressed: () async {
                    try {
                      await context.read<CreateBookingCubit>().createBooking();
                    } on StripeException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Error: ${e.error.localizedMessage}'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Error making payment'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.book),
                  label: state.status.isInProgress
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : const Text('Confirm'),
                );
              },
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                children: [
                  const Row(
                    children: [
                      Text(
                        'Band',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<UserModel?>(
                    future: database.getUserById(requesteeId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SkeletonListTile();
                      }

                      final requestee = snapshot.data;
                      if (requestee == null) {
                        return SkeletonListTile();
                      }

                      return UserTile(user: requestee);
                    },
                  ),
                  const CreateBookingForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
