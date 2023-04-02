import 'package:flutter/cupertino.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
