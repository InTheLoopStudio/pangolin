import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:timeago/timeago.dart' as timeago;

class BadgeContainer extends StatelessWidget {
  const BadgeContainer({
    Key? key,
    required this.badge,
  }) : super(key: key);

  final Badge badge;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
