import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

enum DynamicLinkType {
  createPost,
  shareLoop,
  shareProfile,
}

class DynamicLinkRedirect {
  const DynamicLinkRedirect({
    required this.type,
    this.id,
  });

  final DynamicLinkType type;
  final String? id;
}

abstract class DynamicLinkRepository {
  Stream<DynamicLinkRedirect> getDynamicLinks();
  Future<String> getShareLoopDynamicLink(Loop loop);
  Future<String> getShareProfileDynamicLink(UserModel user);
}
