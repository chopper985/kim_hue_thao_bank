import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preny/core/app/themes/service/theme_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  ThemeMode currentThemeMode = ThemeMode.light;

  updateTheme(ThemeMode mode) {
    ThemeService().changeThemeMode(mode: currentThemeMode);
    emit(ThemeUpdated(mode: currentThemeMode));
  }
}
