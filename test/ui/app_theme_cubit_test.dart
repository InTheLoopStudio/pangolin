import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    final storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory(),
    );
    print(storage);
  });

  group('AppThemeCubit', () {
    blocTest(
      'emit `true` when theme updated to dark',
      build: () => AppThemeCubit(),
      expect: () => [],
    );

    blocTest(
      'emit `true` when theme updated to dark',
      build: () => AppThemeCubit(),
      act: (AppThemeCubit bloc) => bloc.updateTheme(true),
      expect: () => [true],
    );

    blocTest(
      'emit `false` when theme updated to light',
      build: () => AppThemeCubit(),
      act: (AppThemeCubit bloc) => bloc.updateTheme(false),
      expect: () => [false],
    );
  });
}
