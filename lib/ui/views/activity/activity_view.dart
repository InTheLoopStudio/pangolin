import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/widgets/activity_view/activity_list.dart';

class ActivityView extends StatelessWidget {
  ActivityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ActivityList(),
    );
  }
}
