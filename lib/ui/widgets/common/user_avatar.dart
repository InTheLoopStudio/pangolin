import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/widgets/common/conditional_parent_widget.dart';
import 'package:stream_chat_flutter/conditional_parent_builder/conditional_parent_builder.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.pushId,
    this.imageUrl,
    this.verified,
    this.radius,
    this.minRadius,
    this.maxRadius,
  });

  final String? pushId;
  final String? imageUrl;
  final bool? verified;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;

  Widget Function({
    required Widget child,
  }) _pushProfile(BuildContext context) {
    return ({
      required Widget child,
    }) {
      final id = pushId;
      if (id == null) {
        return child;
      }

      return GestureDetector(
        onTap: () => context.read<NavigationBloc>().add(
              PushProfile(
                id,
              ),
            ),
        child: child,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalParentWidget(
      condition: pushId != null,
      conditionalBuilder: _pushProfile(context),
      child: badges.Badge(
        position: badges.BadgePosition.bottomEnd(end: -5, bottom: -4),
        badgeContent: const Icon(
          Icons.check,
          color: Colors.white,
          size: 10,
        ),
        showBadge: verified ?? false,
        badgeStyle: const badges.BadgeStyle(
          shape: badges.BadgeShape.twitter,
          badgeColor: tappedAccent,
        ),
        child: CircleAvatar(
          radius: radius,
          minRadius: minRadius,
          maxRadius: maxRadius,
          foregroundImage: (imageUrl == null || imageUrl!.isEmpty)
              ? const AssetImage('assets/default_avatar.png') as ImageProvider
              : CachedNetworkImageProvider(
                  imageUrl!,
                  errorListener: () {
                    return;
                  },
                ),
          backgroundImage: const AssetImage('assets/default_avatar.png'),
        ),
      ),
    );
  }
}
