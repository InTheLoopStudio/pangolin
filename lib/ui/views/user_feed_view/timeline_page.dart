import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/user_feed_view/compose_activity_page.dart';
import 'package:intheloopapp/ui/views/user_feed_view/list_activity_item.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// Page that displays the "timeline" Stream feed group.
///
/// This is a combination of your activities, and the users you follow.
///
/// Displays your reactions, and reaction counts.
class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final EnrichmentFlags _flags = EnrichmentFlags()
    ..withReactionCounts()
    ..withOwnReactions();

  bool _isPaginating = false;

  static const _feedGroup = 'timeline';

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    if (!_isPaginating) {
      _isPaginating = true;
      context.feedBloc
          .loadMoreEnrichedActivities(feedGroup: _feedGroup, flags: _flags)
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = context.feedClient;
    return Scaffold(
      appBar: AppBar(title: const Text('Timeline')),
      body: FlatFeedCore(
        feedGroup: _feedGroup,
        userId: client.currentUser!.id,
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        emptyBuilder: (context) => const Center(child: Text('No activities')),
        errorBuilder: (context, error) => Center(
          child: Text(error.toString()),
        ),
        limit: 10,
        flags: _flags,
        feedBuilder: (
          BuildContext context,
          activities,
        ) {
          return RefreshIndicator(
            onRefresh: () {
              return context.feedBloc.refreshPaginatedEnrichedActivities(
                feedGroup: _feedGroup,
                flags: _flags,
              );
            },
            child: ListView.separated(
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                bool shouldLoadMore = activities.length - 3 == index;
                if (shouldLoadMore) {
                  _loadMore();
                }
                return ListActivityItem(
                  activity: activities[index],
                  feedGroup: _feedGroup,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => const ComposeActivityPage()),
          );
        },
        tooltip: 'Add Activity',
        child: const Icon(Icons.add),
      ),
    );
  }
}
