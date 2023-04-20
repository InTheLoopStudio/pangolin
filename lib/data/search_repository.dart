import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

// ignore: one_member_abstracts
abstract class SearchRepository {
  Future<List<UserModel>> queryUsers(String input);
  Future<List<Loop>> queryLoops(String input);
}
