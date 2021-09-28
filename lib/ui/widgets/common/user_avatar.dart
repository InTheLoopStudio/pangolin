import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    this.backgroundImageUrl,
    this.radius,
    this.minRadius,
    this.maxRadius,
  }) : super(key: key);

  final String? backgroundImageUrl;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      minRadius: minRadius,
      maxRadius: maxRadius,
      backgroundImage:
          (backgroundImageUrl == null || backgroundImageUrl!.isEmpty)
              ? AssetImage('assets/default_avatar.png') as ImageProvider
              : CachedNetworkImageProvider(
                  backgroundImageUrl!,
                ),
    );
  }
}
