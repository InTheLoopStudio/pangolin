import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

// ignore: one_member_abstracts
abstract class SearchRepository {
  Future<List<UserModel>> queryUsers(
    String input, {
    List<String>? labels,
    List<String>? genres,
    List<String>? occupations,
    double? lat,
    double? lng,
    int radius = 50000,
  });
  Future<List<Loop>> queryLoops(String input);
}
