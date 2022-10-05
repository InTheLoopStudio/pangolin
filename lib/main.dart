import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/data/notification_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/dependencies.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/down_for_maintenance_bloc/down_for_maintenance_bloc.dart';
import 'package:intheloopapp/domains/dynamic_link_bloc/dynamic_link_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/simple_bloc_observer.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/down_for_maintenance_view.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/login/login_view.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_view.dart';
import 'package:intheloopapp/ui/views/shell/shell_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background,
  // such as Firestore, make sure you call
  // `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  await Firebase.initializeApp();

  // Keep the app in portrait mode (no landscape)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Bloc.observer = SimpleBlocObserver();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  HydratedBlocOverrides.runZoned(
    () => runApp(TappedApp()),
    storage: storage,
  );
}

/// The root widget for the app
class TappedApp extends StatelessWidget {
  /// create the root widget for the app
  TappedApp({Key? key}) : super(key: key);

  static final _analytics = FirebaseAnalytics.instance;
  static final _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  final _client = StreamChatClient(
    'xyk6dwdsp422',
    logLevel: Level.INFO,
  );

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en-US');
    return MultiRepositoryProvider(
      providers: buildRepositories(streamChatClient: _client),
      child: MultiBlocProvider(
        providers: buildBlocs(navigatorKey: _navigatorKey),
        child: BlocBuilder<AppThemeCubit, bool>(
          builder: (context, isDarkSnapshot) {
            final appTheme =
                isDarkSnapshot ? Themes.themeDark : Themes.themeLight;
            final defaultStreamTheme = StreamChatThemeData.fromTheme(appTheme);
            final streamTheme = defaultStreamTheme;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Tapped',
              theme: appTheme,
              navigatorObservers: <NavigatorObserver>[_observer],
              navigatorKey: _navigatorKey,
              builder: (context, widget) {
                return StreamChat(
                  client: _client,
                  streamChatThemeData: streamTheme,
                  child: widget,
                );
              },
              home:
                  BlocBuilder<DownForMaintenanceBloc, DownForMaintenanceState>(
                builder: (context, state) {
                  if (state.downForMaintenance) {
                    return const DownForMainenanceView();
                  }

                  return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (BuildContext context, AuthenticationState state) {
                      if (state is Uninitialized) {
                        return const LoadingView();
                      }
                      if (state is Authenticated) {
                        context
                            .read<DynamicLinkBloc>()
                            .add(MonitorDynamicLinks());
                        context
                            .read<OnboardingBloc>()
                            .add(OnboardingCheck(user: state.currentUser));
                        context
                            .read<StreamRepository>()
                            .connectUser(state.currentUser);
                        context
                            .read<NotificationRepository>()
                            .saveDeviceToken(user: state.currentUser);

                        context.read<ActivityBloc>().add(InitListenerEvent());

                        return BlocBuilder<OnboardingBloc, OnboardingState>(
                          builder: (context, state) {
                            if (state is Onboarded) {
                              return const ShellView();
                            } else if (state is Onboarding) {
                              return const OnboardingView();
                            } else if (state is OnboardingInitial) {
                              return const LoadingView();
                            } else {
                              return const LoadingView();
                            }
                          },
                        );
                      }

                      if (state is Unauthenticated) {
                        return const LoginView();
                      }

                      return const LoadingView();
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
