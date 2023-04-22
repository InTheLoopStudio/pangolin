import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/common/tapped_app_bar.dart';

class AdvancedSearchView extends StatelessWidget {
  const AdvancedSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const TappedAppBar(
        title: 'Advanced Search',
      ),
      body: const Center(
        child: Text('coming soon'),
      ),
    );
  }
}
