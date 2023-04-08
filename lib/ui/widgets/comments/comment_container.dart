import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentContainer extends StatelessWidget {
  const CommentContainer({required this.comment, super.key});
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    return FutureBuilder<UserModel?>(
      future: databaseRepository.getUserById(comment.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final user = snapshot.data!;

        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: ListTile(
            leading: UserAvatar(
              radius: 20,
              backgroundImageUrl: user.profilePicture,
            ),
            trailing: Text(
              timeago.format(
                comment.timestamp.toDate(),
                locale: 'en_short',
              ),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            title: Text(
              user.displayName,
            ),
            subtitle: Text(
              comment.content,
            ),
          ),
        );
      },
    );
  }
}
