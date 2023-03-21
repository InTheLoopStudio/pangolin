import 'package:flutter/material.dart';

class SocialActionButton extends StatelessWidget {
  const SocialActionButton({
    super.key,
    this.title,
    this.icon,
    this.onTap,
    this.color = Colors.grey,
    this.width = 60,
    this.height = 60,
    this.iconSize = 35,
  });

  final String? title;
  final IconData? icon;
  final Color? color;
  final void Function()? onTap;
  final double width;
  final double height;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Icon(
              icon,
              size: iconSize,
              color: color,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
