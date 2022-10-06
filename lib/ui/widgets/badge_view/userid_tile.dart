import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';

class UseridTile extends StatelessWidget {
  const UseridTile({
    Key? key,
    required this.userid,
  }) : super(key: key);

  final String userid;

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    return FutureBuilder(
      future: databaseRepository.getUser(userid),
      builder: (
        BuildContext context,
        AsyncSnapshot<UserModel> snapshot,
      ) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final user = snapshot.data!;
        return UserTile(user: user);
      },
    );
  }
}
