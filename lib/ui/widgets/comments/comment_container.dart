import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentContainer extends StatelessWidget {
  final Comment comment;

  const CommentContainer({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseRepository databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    return FutureBuilder<UserModel>(
      future: databaseRepository.getUser(comment.userId!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        UserModel user = snapshot.data!;

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: ListTile(
            leading: UserAvatar(
              radius: 20,
              backgroundImageUrl: user.profilePicture,
            ),
            trailing: Text(
              timeago.format(
                comment.timestamp!.toDate(),
                locale: 'en_short',
              ),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            title: Text(
              user.username,
            ),
            subtitle: Text(
              comment.content!,
            ),
          ),
        );
      },
    );
  }
}
