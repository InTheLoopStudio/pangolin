import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge_model;
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class BadgeContainer extends StatelessWidget {
  const BadgeContainer({
    required this.badge,
    super.key,
  });

  final badge_model.Badge badge;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.read<NavigationBloc>().add(
                PushBadge(badge),
              ),
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: badge.imageUrl,
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
            title: Text(badge.name),
            subtitle: Text(badge.description),
            trailing: Text(
              timeago.format(
                badge.timestamp,
                locale: 'en_short',
              ),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}
