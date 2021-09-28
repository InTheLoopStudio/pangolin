import 'package:intheloopapp/domains/models/user_model.dart';

abstract class SearchRepository {
  Future<List<UserModel>> queryUsers(String input);
}
