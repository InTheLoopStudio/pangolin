import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/post.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostContainer extends StatelessWidget {
  const PostContainer({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    final navigationBloc = context.read<NavigationBloc>();
    return FutureBuilder<UserModel?>(
      future: databaseRepository.getUserById(post.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final user = snapshot.data;
        if (user == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => navigationBloc.add(PushProfile(user.id)),
                child: Row(
                  children: [
                    Column(
                      children: [
                        // + User Avatar
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: user.profilePicture.isEmpty
                              ? const AssetImage('assets/default_avatar.png')
                                  as ImageProvider
                              : CachedNetworkImageProvider(
                                  user.profilePicture,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 28,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.artistName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${user.username}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          timeago.format(
                            post.timestamp,
                            locale: 'en_short',
                          ),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                post.description,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

              // TODO(jonaylor89): add like and comment buttons

              const SizedBox(height: 14),
              const Divider(
                color: Colors.grey,
                height: 10,
                thickness: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
