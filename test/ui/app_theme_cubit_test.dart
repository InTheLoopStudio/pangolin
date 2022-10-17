import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:mockito/mockito.dart';

class MockStorage extends Mock implements Storage {
  @override
  Future<void> write(String key, dynamic value) async {}
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBlocOverrides.runZoned(
    () {
      group('AppThemeCubit', () {
        blocTest<AppThemeCubit, bool>(
          'emit `true` when theme updated to dark',
          build: () => AppThemeCubit(),
          expect: () => <bool>[],
        );

        blocTest<AppThemeCubit, bool>(
          'emit `true` when theme updated to dark',
          build: () => AppThemeCubit(),
          act: (AppThemeCubit bloc) => bloc.updateTheme(isDarkMode: true),
          expect: () => [true],
        );

        blocTest<AppThemeCubit, bool>(
          'emit `false` when theme updated to light',
          build: () => AppThemeCubit(),
          act: (AppThemeCubit bloc) => bloc.updateTheme(isDarkMode: false),
          expect: () => [false],
        );
      });
    },
    storage: MockStorage(),
  );
}
