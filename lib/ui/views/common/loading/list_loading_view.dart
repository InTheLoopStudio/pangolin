import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ListLoadingView extends StatelessWidget {
  const ListLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/default_avatar.png'),
          ),
          title: SizedBox(
            height: 10,
            child: SkeletonAnimation(
              shimmerColor: Colors.grey,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          subtitle: SizedBox(
            height: 10,
            child: SkeletonAnimation(
              shimmerColor: Colors.grey,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          trailing: const Text(''),
        );
      },
    );
  }
}
