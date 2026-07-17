import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/core/services/local/user_prefs.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(UserPrefs.isDarkMode()); // Load from SharedPreferences

  void toggleTheme() {
    final newValue = !state;
    UserPrefs.setIsDarkMode(newValue);
    emit(newValue);
  }

  void updateTheme(bool isDark) {
    if (state != isDark) {
      UserPrefs.setIsDarkMode(isDark);
      emit(isDark);
    }
  }
}
