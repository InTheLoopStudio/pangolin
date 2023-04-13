import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// UI widget that displays a [TextField] to add a [Reaction]/Comment to a
/// particular [activity].
class AddCommentBox extends StatefulWidget {
  const AddCommentBox({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final EnrichedActivity activity;

  @override
  State<AddCommentBox> createState() => _AddCommentBoxState();
}

class _AddCommentBoxState extends State<AddCommentBox> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final value = textController.text;
    textController.clear();

    if (value.isNotEmpty) {
      context.feedBloc.onAddReaction(
        kind: 'comment',
        activity: widget.activity,
        feedGroup: 'timeline',
        data: {'text': value},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 32),
      child: TextField(
        controller: textController,
        onSubmitted: ((value) {
          _addComment();
        }),
        decoration: InputDecoration(
          hintText: 'Add a comment',
          suffix: IconButton(
            onPressed: _addComment,
            icon: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}
