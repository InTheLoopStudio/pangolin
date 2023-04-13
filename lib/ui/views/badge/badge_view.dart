import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge_model;
import 'package:intheloopapp/ui/widgets/badge_view/userid_tile.dart';

/// The full page view for a badge
class BadgeView extends StatelessWidget {
  /// Just a badge model is required for the view
  const BadgeView({
    required this.badge,
    super.key,
  });

  /// The badge to display
  final badge_model.Badge badge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
              Hero(
                tag: badge.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(imageUrl: badge.imageUrl),
                ),
              ),
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
                'Creator',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              UseridTile(userid: badge.creatorId),
            ],
          ),
        ),
      ),
    );
  }
}
