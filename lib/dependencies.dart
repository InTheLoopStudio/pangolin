import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/data/image_picker_repository.dart';
import 'package:intheloopapp/data/local/image_picker_impl.dart';
import 'package:intheloopapp/data/notification_repository.dart';
import 'package:intheloopapp/data/prod/algolia_search_impl.dart';
import 'package:intheloopapp/data/prod/cloud_messaging_impl.dart';
import 'package:intheloopapp/data/prod/firebase_auth_impl.dart';
import 'package:intheloopapp/data/prod/firebase_dynamic_link_impl.dart';
import 'package:intheloopapp/data/prod/firebase_storage_impl.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/data/prod/remote_config_impl.dart';
import 'package:intheloopapp/data/prod/stream_impl.dart';
import 'package:intheloopapp/data/remote_config_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/down_for_maintenance_bloc/down_for_maintenance_bloc.dart';
import 'package:intheloopapp/domains/dynamic_link_bloc/dynamic_link_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

List<RepositoryProvider> buildRepositories(
    {required StreamChatClient streamChatClient}) {
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
    RepositoryProvider<NotificationRepository>(
      create: (_) => CloudMessagingImpl(streamChatClient),
    ),
    RepositoryProvider<RemoteConfigRepository>(
      create: (_) => RemoteConfigImpl()..fetchAndActivate(),
    ),
    RepositoryProvider<StreamRepository>(
      create: (_) => StreamImpl(streamChatClient),
    ),
  ];
}

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
        databaseRepository: context.read<DatabaseRepository>(),
      )..add(AppStarted()),
    ),
    BlocProvider<NavigationBloc>(
      create: (_) => NavigationBloc(navigationKey: navigatorKey),
    ),
    BlocProvider<OnboardingBloc>(
      create: (_) => OnboardingBloc(),
    ),
    BlocProvider<DynamicLinkBloc>(
      create: (context) => DynamicLinkBloc(
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
  ];
}
