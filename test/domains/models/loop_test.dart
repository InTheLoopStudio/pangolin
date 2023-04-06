import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'loop_test.mocks.dart';

@GenerateMocks([DocumentSnapshot])
void main() {
  test('Loops should be able to be created from DocumentSnapshots', () {
    final DocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot =
        MockDocumentSnapshot<Map<String, dynamic>>();

    when(mockDocumentSnapshot.data()).thenReturn(
      {
        'id': '',
        'userId': '',
        'title': '',
        'description': '',
        'audioPath': '',
        'timestamp': Timestamp.now(),
        'likeCount': 0,
        'commentCount': 0,
        'shareCount': 0,
        'tags': const <String>[],
        'deleted': false,
      },
    );

    when(mockDocumentSnapshot.id).thenReturn('');

    final loop = Loop.fromDoc(mockDocumentSnapshot);
    expect(
      loop,
      Loop(
        id: '',
        userId: '',
        title: '',
        description: '',
        audioPath: '',
        imagePaths: const [],
        timestamp: DateTime.now(),
        likeCount: 0,
        commentCount: 0,
        shareCount: 0,
        // tags: const [],
        deleted: false,
      ),
    );
  });
}
