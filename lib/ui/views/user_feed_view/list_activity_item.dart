import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/user_feed_view/comments_page.dart';
import 'package:intheloopapp/ui/views/user_feed_view/user_data.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// UI widget to display an activity/post.
///
/// Shows the number of likes and comments.
///
/// Enables the current [User] to like the activity, and view comments.
class ListActivityItem extends StatelessWidget {
  const ListActivityItem({
    required this.activity,
    required this.feedGroup,
    super.key,
  });

  final EnrichedActivity activity;
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    final actor = activity.actor!;
    final attachments = (activity.extraData)?.toAttachments();
    final reactionCounts = activity.reactionCounts;
    final ownReactions = activity.ownReactions;
    final isLikedByUser = (ownReactions?['like']?.length ?? 0) > 0;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(actor.image),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(actor.name),
            const SizedBox(width: 8),
            Text(
              actor.handle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('${activity.object}'),
          ),
          if (attachments != null && attachments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(attachments[0].url),
            ),
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 16,
                    onPressed: () {
                      if (isLikedByUser) {
                        context.feedBloc.onRemoveReaction(
                          kind: 'like',
                          activity: activity,
                          reaction: ownReactions!['like']![0],
                          feedGroup: feedGroup,
                        );
                      } else {
                        context.feedBloc.onAddReaction(
                          kind: 'like',
                          activity: activity,
                          feedGroup: feedGroup,
                        );
                      }
                    },
                    icon: isLikedByUser
                        ? const Icon(Icons.favorite_rounded)
                        : const Icon(Icons.favorite_outline),
                  ),
                  if (reactionCounts?['like'] != null)
                    Text(
                      '${reactionCounts?['like']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  IconButton(
                    iconSize: 16,
                    onPressed: () => _navigateToCommentPage(context),
                    icon: const Icon(Icons.mode_comment_outlined),
                  ),
                  if (reactionCounts?['comment'] != null)
                    Text(
                      '${reactionCounts?['comment']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                ],
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        _navigateToCommentPage(context);
      },
    );
  }

  void _navigateToCommentPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CommentsPage(
          activity: activity,
        ),
      ),
    );
  }
}
