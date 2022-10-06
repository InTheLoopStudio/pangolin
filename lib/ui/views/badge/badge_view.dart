import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/ui/widgets/badge_view/userid_tile.dart';

/// The full page view for a badge
class BadgeView extends StatelessWidget {
  /// Just a badge model is required for the view
  const BadgeView({
    Key? key,
    required this.badge,
  }) : super(key: key);

  /// The badge to display
  final Badge badge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              badge.name,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              CachedNetworkImage(imageUrl: badge.imageUrl),
              const SizedBox(height: 30),
              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              Text(badge.description),
              const SizedBox(height: 30),
              const Text(
                'Sender',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              UseridTile(userid: badge.senderId),
              const SizedBox(height: 30),
              const Text(
                'Receiver',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              UseridTile(userid: badge.receiverId),
            ],
          ),
        ),
      ),
    );
  }
}
