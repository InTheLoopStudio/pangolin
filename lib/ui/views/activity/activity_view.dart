import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/widgets/activity_view/activity_list.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              'Activities',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: const ActivityList(),
    );
  }
}
