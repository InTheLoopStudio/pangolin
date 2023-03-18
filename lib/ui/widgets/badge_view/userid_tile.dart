import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';

class UseridTile extends StatelessWidget {
  const UseridTile({
    required this.userid,
    Key? key,
  }) : super(key: key);

  final String userid;

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    return FutureBuilder(
      future: databaseRepository.getUserById(userid),
      builder: (
        BuildContext context,
        AsyncSnapshot<UserModel?> snapshot,
      ) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final user = snapshot.data!;
        return UserTile(user: user);
      },
    );
  }
}
