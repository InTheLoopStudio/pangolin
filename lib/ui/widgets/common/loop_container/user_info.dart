import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserInfo extends StatelessWidget {
  const UserInfo({
    required this.loopUser,
    required this.timestamp,
    super.key,
  });

  final UserModel loopUser;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final database = context.read<DatabaseRepository>();
    return FutureBuilder<bool>(
      future: database.isVerified(loopUser.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final verified = snapshot.data!;

        return GestureDetector(
          onTap: () => navigationBloc.add(PushProfile(loopUser.id)),
          child: Row(
            children: [
              Column(
                children: [
                  // + User Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: loopUser.profilePicture.isEmpty
                        ? const AssetImage(
                            'assets/default_avatar.png',
                          ) as ImageProvider
                        : CachedNetworkImageProvider(
                            loopUser.profilePicture,
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
                  if (loopUser.artistName.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          loopUser.artistName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        if (verified)
                          const Icon(
                            Icons.verified,
                            size: 14,
                            color: tappedAccent,
                          )
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  Text(
                    '@${loopUser.username}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    timeago.format(
                      timestamp,
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
        );
      },
    );
  }
}
