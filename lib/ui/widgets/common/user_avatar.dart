import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/widgets/common/conditional_parent_widget.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.pushId = const None(),
    this.pushUser = const None(),
    this.imageUrl,
    this.verified,
    this.radius,
    this.minRadius,
    this.maxRadius,
  });

  final Option<String> pushId;
  final Option<UserModel> pushUser;
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
      return switch ((pushId, pushUser)) {
        (None(), None()) => child,
        (Some(:final value), None()) => GestureDetector(
            onTap: () => context.read<NavigationBloc>().add(
                  PushProfile(
                    value,
                    const None(),
                  ),
                ),
            child: child,
          ),
        (_, Some(:final value)) => GestureDetector(
            onTap: () => context.read<NavigationBloc>().add(
                  PushProfile(
                    value.id,
                    pushUser,
                  ),
                ),
            child: child,
          ),
      };
    };
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalParentWidget(
      condition: pushId.isSome,
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
