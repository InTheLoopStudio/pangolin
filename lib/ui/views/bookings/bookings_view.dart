import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/bookings/bookings_cubit.dart';
import 'package:intheloopapp/ui/widgets/booking_view/bookings_list.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, onboardState) {
        final currentUser = onboardState.currentUser;
        return BlocProvider(
          create: (context) => BookingsCubit(
            currentUserId: currentUser.id,
            accountType: currentUser.accountType,
            databaseRepository:
                RepositoryProvider.of<DatabaseRepository>(context),
          )..initBookings(),
          child: BlocBuilder<BookingsCubit, BookingsState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: context.read<BookingsCubit>().initBookings,
                child: Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  appBar: AppBar(
                    title: const Row(
                      children: [
                        Text(
                          'Bookings',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: BlocBuilder<BookingsCubit, BookingsState>(
                    builder: (context, state) {
                      return CustomScrollView(
                        slivers: [
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 12),
                          ),
                          const SliverToBoxAdapter(
                            child: Text(
                              'Booking Requests',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          BookingsList(
                            bookings: state.pendingBookings,
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 12),
                          ),
                          const SliverToBoxAdapter(
                            child: Text(
                              'Upcoming Bookings',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          BookingsList(
                            bookings: state.upcomingBookings,
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 12),
                          ),
                          const SliverToBoxAdapter(
                            child: Text(
                              'Past Bookings',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          BookingsList(
                            bookings: state.pastBookings,
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 12),
                          ),
                          const SliverToBoxAdapter(
                            child: Text(
                              'Canceled Bookings',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          BookingsList(
                            bookings: state.canceledBookings,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
