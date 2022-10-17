import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

final _analytics = FirebaseAnalytics.instance;
final _fireStore = FirebaseFirestore.instance;
final usersRef = _fireStore.collection('users');
final Algolia _algolia = const Algolia.init(
  applicationId: 'GCNFAI2WB6',
  apiKey: 'c89ebf37b46a3683405be3ed0901f217',
).instance;

class AlgoliaSearchImpl extends SearchRepository {
  Future<UserModel> _getUser(String userId) async {
    final userSnapshot = await usersRef.doc(userId).get();
    final user = UserModel.fromDoc(userSnapshot);

    return user;
  }

  @override
  Future<List<UserModel>> queryUsers(String input) async {
    var results = <AlgoliaObjectSnapshot>[];

    try {
      final query = _algolia.index('prod_users').query(input);

      final snap = await query.getObjects();

      await _analytics.logSearch(searchTerm: input);

      results = snap.hits;
    } on AlgoliaError catch (e) {
      print(e.error);
      rethrow;
    }

    final userResults = await Future.wait(
      results.map((res) async {
        final user = await _getUser(res.objectID);
        return user;
      }),
    );

    return userResults;
  }
}
