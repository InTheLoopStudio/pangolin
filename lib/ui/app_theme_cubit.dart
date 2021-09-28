import 'package:hydrated_bloc/hydrated_bloc.dart';

class AppThemeCubit extends HydratedCubit<bool> {
  AppThemeCubit() : super(true);

  @override
  bool fromJson(Map<String, dynamic> json) => json['isDark'];

  @override
  Map<String, dynamic> toJson(bool state) => {'isDark': state};

  Future<void> updateTheme(bool isDarkMode) async {
    emit(isDarkMode);
  }

  bool isDark() {
    return state;
  }
}
