import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_container.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:skeletons/skeletons.dart';

class ListLoadingView extends StatelessWidget {
  const ListLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: const LoadingContainer(),
        ),
      ),
    );
  }
}
