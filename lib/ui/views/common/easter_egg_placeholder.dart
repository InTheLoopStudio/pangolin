import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EasterEggPlaceholder extends StatefulWidget {
  const EasterEggPlaceholder({
    Key? key,
    this.text = '',
    this.color,
  }) : super(key: key);

  final String text;
  final Color? color;

  @override
  _EasterEggPlaceholderState createState() => _EasterEggPlaceholderState();
}

class _EasterEggPlaceholderState extends State<EasterEggPlaceholder> {
  int tapCount = 0;

  @override
  Widget build(BuildContext context) {
    Color themeColor = Theme.of(context).primaryIconTheme.color ?? Colors.black;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: (tapCount >= 15)
                ? Icon(
                    FontAwesomeIcons.angry,
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
                      FontAwesomeIcons.surprise,
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
