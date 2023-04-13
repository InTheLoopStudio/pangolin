import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/user_feed_view/add_comment_box.dart';
import 'package:intheloopapp/ui/views/user_feed_view/user_data.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// A page that displays all [Reaction]s/Comments for a specific
/// [Activity]/Post.
///
/// Enabling the current [User] to add comments and like other reactions.
class CommentsPage extends StatefulWidget {
  const CommentsPage({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final EnrichedActivity activity;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  bool _isPaginating = false;

  final EnrichmentFlags _flags = EnrichmentFlags()..withOwnChildren();

  Future<void> _loadMore() async {
    // Ensure we're not already loading more reactions.
    if (!_isPaginating) {
      _isPaginating = true;
      context.feedBloc
          .loadMoreReactions(widget.activity.id!, flags: _flags)
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  Future<void> _addOrRemoveLike(Reaction reaction) async {
    final isLikedByUser = (reaction.ownChildren?['like']?.length ?? 0) > 0;
    if (isLikedByUser) {
      FeedProvider.of(context).bloc.onRemoveChildReaction(
            kind: 'like',
            childReaction: reaction.ownChildren!['like']![0],
            lookupValue: widget.activity.id!,
            parentReaction: reaction,
          );
    } else {
      FeedProvider.of(context).bloc.onAddChildReaction(
            kind: 'like',
            reaction: reaction,
            lookupValue: widget.activity.id!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        children: [
          Expanded(
            child: ReactionListCore(
              lookupValue: widget.activity.id!,
              kind: 'comment',
              loadingBuilder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
              emptyBuilder: (context) =>
                  const Center(child: Text('No comment reactions')),
              errorBuilder: (context, error) => Center(
                child: Text(error.toString()),
              ),
              flags: _flags,
              reactionsBuilder: (context, reactions) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: RefreshIndicator(
                    onRefresh: () {
                      return context.feedBloc.refreshPaginatedReactions(
                        widget.activity.id!,
                        flags: _flags,
                      );
                    },
                    child: ListView.separated(
                      itemCount: reactions.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        bool shouldLoadMore = reactions.length - 3 == index;
                        if (shouldLoadMore) {
                          _loadMore();
                        }

                        final reaction = reactions[index];
                        final isLikedByUser =
                            (reaction.ownChildren?['like']?.length ?? 0) > 0;
                        final user = reaction.user;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user!.image),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${reaction.data?['text']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          trailing: IconButton(
                            iconSize: 14,
                            onPressed: () {
                              _addOrRemoveLike(reaction);
                            },
                            icon: isLikedByUser
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          AddCommentBox(activity: widget.activity)
        ],
      ),
    );
  }
}

