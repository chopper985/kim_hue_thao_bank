part of 'theme_cubit.dart';

sealed class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

final class ThemeInitial extends ThemeState {}

final class ThemeUpdated extends ThemeState {
  final ThemeMode mode;

  const ThemeUpdated({required this.mode});

  @override
  List<Object> get props => [mode];
}
