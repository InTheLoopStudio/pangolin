import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

final _dynamicLinks = FirebaseDynamicLinks.instance;

/// The Firebase dynamic link implementation for Dynamic Link
///
/// aka Deep Links
class FirebaseDynamicLinkImpl extends DynamicLinkRepository {
  @override
  Stream<DynamicLinkRedirect> getDynamicLinks() async* {
    // ignore: close_sinks
    final dynamicLinkStream = StreamController<DynamicLinkRedirect>();

    final data = await _dynamicLinks.getInitialLink();

    final redirect = _handleDeepLink(data);
    if (redirect != null) {
      dynamicLinkStream.add(redirect);
    }

    _dynamicLinks.onLink
        .listen((PendingDynamicLinkData? dynamicLinkData) async {
      final redirect = _handleDeepLink(dynamicLinkData);

      if (redirect != null) {
        dynamicLinkStream.add(redirect);
      }
    }).onError(
      (error) async {},
    );

    yield* dynamicLinkStream.stream;
  }

  DynamicLinkRedirect? _handleDeepLink(
    PendingDynamicLinkData? data,
  ) {
    final deepLink = data?.link;
    if (deepLink == null) {
      return null;
    }

    // print('_handleDeepLink | deep link: $deepLink');

    switch (deepLink.path) {
      case '/upload_loop':
        return const DynamicLinkRedirect(
          type: DynamicLinkType.CreatePost,
        );
      case '/user':
        final linkParameters = deepLink.queryParameters;
        final userId = linkParameters['id'] ?? '';
        return DynamicLinkRedirect(
          type: DynamicLinkType.ShareProfile,
          id: userId,
        );
      case '/loop':
        final linkParameters = deepLink.queryParameters;
        final loopId = linkParameters['id'] ?? '';
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
    final parameters = DynamicLinkParameters(
      uriPrefix: 'https://tappednetwork.page.link',
      link: Uri.parse(
        'https://intheloopstudio.com/loop?id=${loop.id}',
      ),
      androidParameters: const AndroidParameters(
        packageName: 'com.intheloopstudio',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.intheloopstudio',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Tapped Network | ${loop.title}',
        description:
            'Tapped Network - The online platform tailored for producers and creators to share their loops to the world, get feedback on their music, and join the world-wide community of artists to collaborate with',
      ),
    );

    final shortDynamicLink = await _dynamicLinks.buildShortLink(parameters);
    final shortUrl = shortDynamicLink.shortUrl;

    return shortUrl.toString();
  }

  @override
  Future<String> getShareProfileDynamicLink(UserModel user) async {
    final parameters = DynamicLinkParameters(
      uriPrefix: 'https://tappednetwork.page.link',
      link: Uri.parse('https://tappednetwork.com/user?id=${user.id}'),
      androidParameters: const AndroidParameters(
        packageName: 'com.intheloopstudio',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.intheloopstudio',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: '${user.username} on Tapped',
        description:
            'Tapped Network - The online platform tailored for producers and creators to share their loops to the world, get feedback on their music, and join the world-wide community of artists to collaborate with',
      ),
    );

    final shortDynamicLink = await _dynamicLinks.buildShortLink(parameters);
    final shortUrl = shortDynamicLink.shortUrl;

    return shortUrl.toString();
  }
}
