import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/send_badge/send_badge_view.dart';

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
        OutlinedButton.icon(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SendBadgeView(),
              ),
            );
          },
          icon: Icon(Icons.badge),
          label: Text('Send Badge'),
        ),
        SizedBox(height: 20),
        Text(
          'No Badges Yet',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    ));
  }
}
