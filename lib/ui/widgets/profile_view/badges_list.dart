import 'package:flutter/material.dart';

class BadgesList extends StatefulWidget {
  const BadgesList({Key? key}) : super(key: key);

  @override
  State<BadgesList> createState() => _BadgesListState();
}

class _BadgesListState extends State<BadgesList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        Text('No Badges Yet',
            style: TextStyle(
              color: Colors.grey[600],
            )),
      ],
    ));
  }
}
