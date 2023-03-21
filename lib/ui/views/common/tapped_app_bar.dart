import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TappedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TappedAppBar({
    required this.title,
    this.transparent = true,
    this.trailing,
    super.key,
  });

  final String title;
  final bool transparent;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
