import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

final _dynamicLinks = FirebaseDynamicLinks.instance;

class FirebaseDynamicLinkImpl extends DynamicLinkRepository {
  @override
  Stream<DynamicLinkRedirect> getDynamicLinks() async* {
    StreamController<DynamicLinkRedirect> dynamicLinkStream =
        StreamController();

    final PendingDynamicLinkData? data = await _dynamicLinks.getInitialLink();

    DynamicLinkRedirect? redirect = _handleDeepLink(data);
    if (redirect != null) {
      dynamicLinkStream.add(redirect);
    }

    _dynamicLinks.onLink.listen((PendingDynamicLinkData? dynamicLinkData) async {
        DynamicLinkRedirect? redirect = _handleDeepLink(dynamicLinkData);

        if (redirect != null) {
          dynamicLinkStream.add(redirect);
        }
      }).onError((error) async {
        print('onLinkError');
        print(error.message);
      },
    );

    yield* dynamicLinkStream.stream;
  }

  DynamicLinkRedirect? _handleDeepLink(
    PendingDynamicLinkData? data,
  ) {
    final Uri? deepLink = data?.link;
    if (deepLink == null) {
      return null;
    }

    print('_handleDeepLink | deep link: $deepLink');

    switch (deepLink.path) {
      case '/upload_loop':
        return DynamicLinkRedirect(
          type: DynamicLinkType.CreatePost,
        );
      case '/user':
        final Map<String, String> linkParameters = deepLink.queryParameters;
        final String userId = linkParameters['id'] ?? '';
        return DynamicLinkRedirect(
          type: DynamicLinkType.ShareProfile,
          id: userId,
        );
      case '/loop':
        final Map<String, String> linkParameters = deepLink.queryParameters;
        final String loopId = linkParameters['id'] ?? '';
        return DynamicLinkRedirect(
          type: DynamicLinkType.ShareLoop,
          id: loopId,
        );
      default:
        return null;
    }
  }

  @override
  Future<String> getShareLoopDynamicLink(Loop loop) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://intheloopstudio.page.link',
      link: Uri.parse(
        'https://intheloopstudio.com/loop?id=${loop.id}',
      ),
      androidParameters: AndroidParameters(
        packageName: 'com.intheloopstudio',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.intheloopstudio',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'In The Loop | ${loop.title}',
        description:
            'In The Loop - The online platform tailored for producers and creators to share their loops to the world, get feedback on their music, and join the world-wide community of artists to collaborate with',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await _dynamicLinks.buildShortLink(parameters);
    final Uri shortUrl = shortDynamicLink.shortUrl;

    return shortUrl.toString();
  }

  @override
  Future<String> getShareProfileDynamicLink(UserModel user) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://intheloopstudio.page.link',
      link: Uri.parse('https://intheloopstudio.com/user?id=${user.id}'),
      androidParameters: AndroidParameters(
        packageName: 'com.intheloopstudio',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.intheloopstudio',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: '${user.username} on In The Loop',
        description:
            'In The Loop - The online platform tailored for producers and creators to share their loops to the world, get feedback on their music, and join the world-wide community of artists to collaborate with',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await _dynamicLinks.buildShortLink(parameters);
    final Uri shortUrl = shortDynamicLink.shortUrl;

    return shortUrl.toString();
  }
}
