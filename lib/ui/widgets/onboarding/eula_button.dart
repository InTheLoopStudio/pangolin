import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EULAButton extends StatelessWidget {
  const EULAButton({
    required this.onChanged,
    required this.initialValue,
    super.key,
  });

  final bool initialValue;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: initialValue,
          onChanged: onChanged.call,
        ),
        GestureDetector(
          onTap: () {
            launchUrl(
              Uri.parse('https://tapped.ai/terms'),
            );
          },
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'I agree to the ',
                ),
                TextSpan(
                  text: 'EULA',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                ),
                const WidgetSpan(
                  child: Icon(
                    Icons.launch,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
