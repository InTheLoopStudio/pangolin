import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';

class InterestedView extends StatelessWidget {
  const InterestedView({
    required this.loop,
    super.key,
  });

  final Loop loop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final database = context.read<DatabaseRepository>();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Interested Users'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: database.getInterestedUsers(loop.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return UserTile(user: users[index]);
            },
          );
        },
      ),
    );
  }
}
