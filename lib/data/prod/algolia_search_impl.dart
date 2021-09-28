import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

final _fireStore = FirebaseFirestore.instance;
final usersRef = _fireStore.collection('users');
final Algolia _algolia = Algolia.init(
  applicationId: 'GCNFAI2WB6',
  apiKey: 'c89ebf37b46a3683405be3ed0901f217',
).instance;

class AlgoliaSearchImpl extends SearchRepository {
  Future<UserModel> _getUser(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await usersRef.doc(userId).get();
    UserModel user = UserModel.fromDoc(userSnapshot);

    return user;
  }

  Future<List<UserModel>> queryUsers(String input) async {
    List<AlgoliaObjectSnapshot> results = [];

    try {
      AlgoliaQuery query = _algolia.index('prod_users').query(input);

      AlgoliaQuerySnapshot snap = await query.getObjects();

      results = snap.hits;
    } on AlgoliaError catch (e) {
      print(e.error);
      throw e;
    }

    List<UserModel> userResults = await Future.wait(
      results.map((res) async {
        UserModel user = await _getUser(res.objectID);
        return user;
      }),
    );

    return userResults;
  }
}
