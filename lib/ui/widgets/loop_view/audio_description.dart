import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';

class AudioDescription extends StatelessWidget {
  const AudioDescription({
    Key? key,
    required this.loop,
    required this.user,
  }) : super(key: key);
  final Loop loop;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<ProfileView>(
                  builder: (context) => ProfileView(
                    visitedUserId: user.id,
                  ),
                ),
              );
            },
            child: Text(
              user.username,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.music_note,
                size: 24,
                color: Colors.white,
              ),
              Text(
                loop.title,
                style: const TextStyle(
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
