import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/user_feed_view/compose_activity_page.dart';
import 'package:intheloopapp/ui/views/user_feed_view/list_activity_item.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// Page that displays the "user" Stream feed group.
///
/// A list of the activities that you've posted.
///
/// Displays your reactions, and reaction counts.
class UserFeedView extends StatefulWidget {
  const UserFeedView({
    super.key,
  });

  @override
  State<UserFeedView> createState() => _UserFeedViewState();
}

class _UserFeedViewState extends State<UserFeedView> {
  final EnrichmentFlags _flags = EnrichmentFlags()
    ..withReactionCounts()
    ..withOwnReactions();

  bool _isPaginating = false;

  static const _feedGroup = 'user';

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    if (!_isPaginating) {
      _isPaginating = true;
      await context.feedBloc
          .loadMoreEnrichedActivities(feedGroup: _feedGroup)
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = context.feedClient;
    return Scaffold(
      appBar: AppBar(title: const Text('Your posts')),
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
