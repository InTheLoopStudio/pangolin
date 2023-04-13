import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// A page to compose a new [Activity]/post.
///
/// - feed: "user"
/// - verb: "post"
/// - object: "text data"
/// - data: media
///
/// [More information](https://getstream.io/activity-feeds/docs/flutter-dart/adding_activities/?language=dart) on activities.
class ComposeActivityPage extends StatefulWidget {
  const ComposeActivityPage({super.key});

  @override
  State<ComposeActivityPage> createState() => _ComposeActivityPageState();
}

class _ComposeActivityPageState extends State<ComposeActivityPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  /// "Post" a new activity to the "user" feed group.
  Future<void> post() async {
    final uploadController = context.feedUploadController;
    final media = uploadController.getMediaUris()?.toExtraData();
    if (_textEditingController.text.isNotEmpty) {
      await context.feedBloc.onAddActivity(
        feedGroup: 'user',
        verb: 'post',
        object: _textEditingController.text,
        data: media,
      );
      uploadController.clear();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot post with no message')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ActionChip(
              label: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              backgroundColor: Colors.white,
              onPressed: post,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textEditingController,
                  decoration:
                      const InputDecoration(hintText: "What's on your mind"),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image = await _picker.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 600,
                        maxWidth: 300,
                        imageQuality: 50,
                      );

                      if (image != null) {
                        await context.feedUploadController
                            .uploadImage(AttachmentFile(path: image.path));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cancelled')));
                      }
                    },
                    icon: const Icon(Icons.file_copy),
                  ),
                  Text(
                    'Add image',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              UploadListCore(
                uploadController: context.feedUploadController,
                loadingBuilder: (context) =>
                    const Center(child: CircularProgressIndicator()),
                uploadsErrorBuilder: (error) =>
                    Center(child: Text(error.toString())),
                uploadsBuilder: (context, uploads) {
                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: uploads.length,
                      itemBuilder: (context, index) => FileUploadStateWidget(
                          fileState: uploads[index],
                          onRemoveUpload: (attachment) {
                            return context.feedUploadController
                                .removeUpload(attachment);
                          },
                          onCancelUpload: (attachment) {
                            return context.feedUploadController
                                .cancelUpload(attachment);
                          },
                          onRetryUpload: (attachment) async {
                            return context.feedUploadController
                                .uploadImage(attachment);
                          }),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
