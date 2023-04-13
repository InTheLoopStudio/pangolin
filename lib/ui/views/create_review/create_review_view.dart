import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/ui/views/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/views/create_review/cubit/create_review_cubit.dart';

class CreateReviewView extends StatelessWidget {
  const CreateReviewView({
    required this.booking,
    super.key,
  });

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateReviewCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const TappedAppBar(
          title: 'Create Review',
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Show who youre reviewing'),
            Text('Show where theyre the performer or booking person'),
            Text('overall rating'),
            Text('fan engagement rating'),
            Text('on time'),
            Text('comments'),
          ],
        ),
      ),
    );
  }
}
