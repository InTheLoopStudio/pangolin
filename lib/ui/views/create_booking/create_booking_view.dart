import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:uuid/uuid.dart';

class CreateBookingView extends StatelessWidget {
  const CreateBookingView({required this.requesteeId, Key? key})
      : super(key: key);

  final String requesteeId;

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, state) {
        final currentUser = state.currentUser;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: const Text('booking'),
          ),
          body: Column(
            children: [
              const Text('booking form'),
              const Text(
                'What night are you booking for (maybe make this a range?)',
              ),
              const Text('Event name (optional)'),
              const Text('Intro note (make this a long form paragraph)'),
              CupertinoButton.filled(
                onPressed: () {
                  final booking = Booking(
                    id: const Uuid().v4(),
                    requesterId: currentUser.id,
                    requesteeId: requesteeId,
                    status: BookingStatus.pending,
                    startTime: DateTime.parse('2023-04-04 13:00:00'),
                    endTime: DateTime.parse('2023-04-04 14:00:00'),
                    timestamp: DateTime.now(),
                  );
                  databaseRepository.createBooking(booking);
                  Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );
  }
}
