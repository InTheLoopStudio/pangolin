import 'package:flutter/cupertino.dart';
import 'package:intheloopapp/domains/models/option.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    required this.title,
    super.key,
  });

  final Option<String> title;

  @override
  Widget build(BuildContext context) {
    return switch (title) {
      None() => const SizedBox.shrink(),
      Some(:final value) => Column(
          children: [
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    };
  }
}
