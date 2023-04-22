import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/data/image_picker_repository.dart';
import 'package:intheloopapp/data/local/image_picker_impl.dart';
import 'package:intheloopapp/data/notification_repository.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/prod/algolia_search_impl.dart';
import 'package:intheloopapp/data/prod/audio_service_impl.dart';
import 'package:intheloopapp/data/prod/cloud_messaging_impl.dart';
import 'package:intheloopapp/data/prod/firebase_auth_impl.dart';
import 'package:intheloopapp/data/prod/firebase_dynamic_link_impl.dart';
import 'package:intheloopapp/data/prod/firebase_storage_impl.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/data/prod/google_places_impl.dart';
import 'package:intheloopapp/data/prod/remote_config_impl.dart';
import 'package:intheloopapp/data/prod/stream_impl.dart';
import 'package:intheloopapp/data/prod/stripe_payment_impl.dart';
import 'package:intheloopapp/data/remote_config_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/down_for_maintenance_bloc/down_for_maintenance_bloc.dart';
import 'package:intheloopapp/domains/dynamic_link_bloc/dynamic_link_bloc.dart';
import 'package:intheloopapp/domains/loop_feed_list_bloc/loop_feed_list_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// link all necessary repository interfaces
/// with their respective implementations
List<RepositoryProvider<Object>> buildRepositories({
  required StreamChatClient streamChatClient,
}) {
  return [
    RepositoryProvider<AuthRepository>(
      create: (_) => FirebaseAuthImpl(),
    ),
    RepositoryProvider<DatabaseRepository>(
      create: (_) => FirestoreDatabaseImpl(),
    ),
    RepositoryProvider<StorageRepository>(
      create: (_) => FirebaseStorageImpl(),
    ),
    RepositoryProvider<ImagePickerRepository>(
      create: (_) => ImagePickerImpl(),
    ),
    RepositoryProvider<SearchRepository>(
      create: (_) => AlgoliaSearchImpl(),
    ),
    RepositoryProvider<DynamicLinkRepository>(
      create: (_) => FirebaseDynamicLinkImpl(),
    ),
    RepositoryProvider<StreamRepository>(
      create: (_) => StreamImpl(streamChatClient),
    ),
    RepositoryProvider<NotificationRepository>(
      create: (_) => CloudMessagingImpl(streamChatClient),
    ),
    RepositoryProvider<RemoteConfigRepository>(
      create: (_) => RemoteConfigImpl()..fetchAndActivate(),
    ),
    RepositoryProvider<PaymentRepository>(
      create: (_) => StripePaymentImpl()..initPayments(),
    ),
    RepositoryProvider<PlacesRepository>(
      create: (_) => GooglePlacesImpl(),
    ),
    RepositoryProvider<AudioRepository>(
      create: (_) => AudioServiceImpl()..initAudioService(),
    ),
  ];
}

/// link all blocs with their respective interfaces
List<BlocProvider> buildBlocs({
  required GlobalKey<NavigatorState> navigatorKey,
}) {
  return [
    BlocProvider<AppThemeCubit>(
      create: (_) => AppThemeCubit(),
    ),
    BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
        authRepository: context.read<AuthRepository>(),
      )..add(AppStarted()),
    ),
    BlocProvider<NavigationBloc>(
      create: (_) => NavigationBloc(navigationKey: navigatorKey),
    ),
    BlocProvider<OnboardingBloc>(
      create: (context) => OnboardingBloc(
        databaseRepository: context.read<DatabaseRepository>(),
      ),
    ),
    BlocProvider<DynamicLinkBloc>(
      create: (context) => DynamicLinkBloc(
        onboardingBloc: context.read<OnboardingBloc>(),
        navigationBloc: context.read<NavigationBloc>(),
        dynamicLinkRepository: context.read<DynamicLinkRepository>(),
        databaseRepository: context.read<DatabaseRepository>(),
      ),
    ),
    BlocProvider<DownForMaintenanceBloc>(
      create: (context) => DownForMaintenanceBloc(
        remoteConfigRepository: context.read<RemoteConfigRepository>(),
      )..add(CheckStatus()),
    ),
    BlocProvider<ActivityBloc>(
      create: (context) => ActivityBloc(
        databaseRepository: context.read<DatabaseRepository>(),
        authenticationBloc: context.read<AuthenticationBloc>(),
      ),
    ),
    BlocProvider<BookingsBloc>(
      create: (context) => BookingsBloc(
        database: context.read<DatabaseRepository>(),
        authenticationBloc: context.read<AuthenticationBloc>(),
      ),
    ),
    BlocProvider<LoopFeedListBloc>(
      create: (context) => LoopFeedListBloc(
        initialIndex: 1,
        feedParamsList: [
          FeedParams(
            sourceFunction:
                context.read<DatabaseRepository>().getFollowingLoops,
            sourceStream:
                context.read<DatabaseRepository>().followingLoopsObserver,
            tabTitle: 'Following',
            feedKey: 'following-feed',
            scrollController: ScrollController(),
          ),
          FeedParams(
            sourceFunction: context.read<DatabaseRepository>().getAllLoops,
            sourceStream: context.read<DatabaseRepository>().allLoopsObserver,
            tabTitle: 'For You',
            feedKey: 'for-you-feed',
            scrollController: ScrollController(),
          ),
        ],
      ),
    ),
    BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        initialIndex: 0,
        database: context.read<DatabaseRepository>(),
        searchRepository: context.read<SearchRepository>(),
        places: context.read<PlacesRepository>(),
      ),
    ),
  ];
}
