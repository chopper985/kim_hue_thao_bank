// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/app/themes/service/theme_service.dart';

part 'theme_state.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  ThemeMode currentThemeMode = ThemeMode.light;

  void updateTheme(ThemeMode mode) {
    ThemeService().changeThemeMode(mode: currentThemeMode);
    emit(ThemeUpdated(mode: currentThemeMode));
  }
}
