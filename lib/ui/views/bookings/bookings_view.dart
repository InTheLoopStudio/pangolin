import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/bookings/bookings_cubit.dart';
import 'package:intheloopapp/ui/views/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/widgets/booking_view/bookings_list.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

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
                  extendBodyBehindAppBar: true,
                  // appBar: const TappedAppBar(title: 'Bookings'),
                  body: BlocBuilder<BookingsCubit, BookingsState>(
                    builder: (context, state) {
                      return CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            pinned: true,
                            backgroundColor: Colors.transparent,
                            systemOverlayStyle: SystemUiOverlayStyle.dark,
                            flexibleSpace: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            title: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
