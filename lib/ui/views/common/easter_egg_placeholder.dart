import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EasterEggPlaceholder extends StatefulWidget {
  const EasterEggPlaceholder({
    super.key,
    this.text = '',
    this.color,
  });

  final String text;
  final Color? color;

  @override
  EasterEggPlaceholderState createState() => EasterEggPlaceholderState();
}

class EasterEggPlaceholderState extends State<EasterEggPlaceholder> {
  int tapCount = 0;

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryIconTheme.color ?? Colors.black;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: (tapCount >= 15)
                ? Icon(
                    FontAwesomeIcons.faceAngry,
                    size: 200,
                    color: widget.color,
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        tapCount++;
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.faceSurprise,
                      size: 200,
                      color: widget.color,
                    ),
                  ),
          ),
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: widget.color ?? themeColor,
            ),
          ),
        ],
      ),
    );
  }
}
