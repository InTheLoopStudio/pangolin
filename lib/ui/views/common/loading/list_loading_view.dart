import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ListLoadingView extends StatelessWidget {
  const ListLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 15,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/default_avatar.png'),
          ),
          title: Container(
            height: 10,
            child: SkeletonAnimation(
              shimmerColor: Colors.grey,
              borderRadius: BorderRadius.circular(20),
              shimmerDuration: 1000,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          subtitle: Container(
            height: 10,
            child: SkeletonAnimation(
              shimmerColor: Colors.grey,
              borderRadius: BorderRadius.circular(20),
              shimmerDuration: 1000,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          trailing: Text(''),
        );
      },
    );
  }
}
