import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/badge.dart';

class BadgeContainer extends StatelessWidget {
  const BadgeContainer({
    Key? key,
    required this.badge,
  }) : super(key: key);

  final Badge badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(50.0),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: CachedNetworkImageProvider(badge.imageUrl),
        ),
      ),
    );
  }
}
