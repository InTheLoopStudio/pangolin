import 'package:hydrated_bloc/hydrated_bloc.dart';

/// The Cubit responsible for changing the app's theme
class AppThemeCubit extends HydratedCubit<bool> {
  /// The default theme is dark mode
  AppThemeCubit() : super(true);

  @override
  bool fromJson(Map<String, dynamic> json) => json['isDark'] as bool;

  @override
  Map<String, dynamic> toJson(bool state) => {'isDark': state};

  /// changes the app theme to be either dark mode
  /// with [isDarkMode] being `true` or
  /// light mode with [isDarkMode] being `false`
  void updateTheme({required bool isDarkMode}) {
    emit(isDarkMode);
  }

  /// Whether the app is dark mode
  bool isDark() {
    return state;
  }
}
