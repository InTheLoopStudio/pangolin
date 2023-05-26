import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UseridTile extends StatelessWidget {
  const UseridTile({
    required this.userid,
    super.key,
  });

  final String userid;

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    return FutureBuilder<Option<UserModel>>(
      future: databaseRepository.getUserById(userid),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return switch (user) {
          null => const CircularProgressIndicator(),
          None() => const CircularProgressIndicator(),
          Some(:final value) => UserTile(user: value),
        };
      },
    );
  }
}
