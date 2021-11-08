import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intheloopapp/utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'utils_test.mocks.dart';

@GenerateMocks([DocumentSnapshot])
void main() {
  group('isSameWeek', () {
    test('true if in current week', () {
      final testDate = DateTime.now();
      expect(isSameWeek(testDate), true);
    });

    test('false if in current week', () {
      final testDate = DateTime.fromMicrosecondsSinceEpoch(0);
      expect(isSameWeek(testDate), false);
    });
  });

  group('getOrElse', () {
    final DocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot =
        MockDocumentSnapshot<Map<String, dynamic>>();

    when(mockDocumentSnapshot.data()).thenReturn({
      'test': 'foo',
    });

    when(mockDocumentSnapshot.id).thenReturn('');

    test('get key that exists', () {
      expect(mockDocumentSnapshot.getOrElse('test', 'bar'), 'foo');
    });

    test('get key that doesnt exists', () {
      expect(mockDocumentSnapshot.getOrElse('TEST', 'bar'), 'bar');
    });
  });
}
