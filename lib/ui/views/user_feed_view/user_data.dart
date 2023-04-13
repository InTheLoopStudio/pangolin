import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// Extension method on Stream's [User] class - to easily access user data
/// properties used in this sample application.
extension UserData on User {
  String get handle => data?['handle'] as String? ?? '';
  String get username => data?['username'] as String? ?? '';
  String get email => data?['email'] as String? ?? '';
  String get name => data?['name'] as String? ?? '';
  String get image => data?['image'] as String? ?? '';
}
