import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();
    return FutureBuilder<List<List<UserModel>>>(
      future: Future.wait([
        database.getViewLeaders(),
        database.getBookingLeaders(),
      ]),
      builder: (context, snapshot) {
        final leaders = snapshot.data ?? [[], []];
        final viewLeaders = leaders[0];
        final bookingLeaders = leaders[1];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Text(
                  'Booking Leaderboards',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (bookingLeaders.isEmpty)
                const Center(
                  child: Text('No leaders rn'),
                ),
              ...bookingLeaders.map((e) => UserTile(user: e)),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Text(
                  'Views Leaderboards',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (viewLeaders.isEmpty)
                const Center(
                  child: Text('No leaders rn'),
                ),
              ...viewLeaders.map((e) => UserTile(user: e)),
            ],
          ),
        );
      },
    );
  }
}
