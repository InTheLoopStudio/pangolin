import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/widgets/advanced_search_view/genre_filter.dart';
import 'package:intheloopapp/ui/widgets/advanced_search_view/label_filter.dart';
import 'package:intheloopapp/ui/widgets/advanced_search_view/location_filter.dart';
import 'package:intheloopapp/ui/widgets/advanced_search_view/occupation_filter.dart';
import 'package:intheloopapp/ui/widgets/advanced_search_view/search_button.dart';

class AdvancedSearchView extends StatelessWidget {
  const AdvancedSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const TappedAppBar(
        title: 'Advanced Search',
      ),
      body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                OccupationFilter(),
                SizedBox(
                  height: 20,
                ),
                GenreFilter(),
                SizedBox(
                  height: 20,
                ),
                LabelFilter(),
                SizedBox(
                  height: 20,
                ),
                LocationFilter(),
                SizedBox(
                  height: 20,
                ),
                SearchButton(),
              ],
            ),
          ),
        ),
    );
  }
}
