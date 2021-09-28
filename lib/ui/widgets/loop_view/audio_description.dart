import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';

class AudioDescription extends StatelessWidget {
  final Loop loop;
  final UserModel user;

  const AudioDescription({
    Key? key,
    required this.loop,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      padding: EdgeInsets.only(left: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileView(
                    visitedUserId: this.user.id,
                  ),
                ),
              );
            },
            child: Text(
              this.user.username,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.music_note,
                size: 24.0,
                color: Colors.white,
              ),
              Text(
                this.loop.title ?? '',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
