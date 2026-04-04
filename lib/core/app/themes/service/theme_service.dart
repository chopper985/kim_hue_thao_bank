// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:AppName/core/app/themes/service/theme_local.dart';

enum ThemeOptions { light, dark }

class ThemeService {
  void switchStatusColor() {
    final SystemUiOverlayStyle systemBrightness = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: ThemeService().getThemeMode() == ThemeMode.dark
          ? Brightness.light
          : Brightness.dark,
      statusBarIconBrightness: ThemeService().getThemeMode() == ThemeMode.dark
          ? Brightness.light
          : Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemBrightness);
  }

  setStatusColor(isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: !isDark ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  ThemeMode getThemeMode() {
    return ThemeMode.values[ThemeLocalData().indexOfThemeMode];
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    ThemeLocalData().saveIndexOfThemeMode(ThemeMode.values.indexOf(mode));
  }

  void changeThemeMode({required ThemeMode mode}) {
    saveThemeMode(mode);
    switchStatusColor();
  }
}
