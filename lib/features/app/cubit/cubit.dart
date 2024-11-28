import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preny/core/injection/injection_container.dart';
import 'package:preny/features/home/cubit/home_cubit.dart';
import 'package:preny/features/theme/cubit/theme_cubit.dart';

class AppCubit {
  static final HomeCubit homeCubit = getIt<HomeCubit>();
  static final ThemeCubit themeCubit = getIt<ThemeCubit>();

  static final List<BlocProvider> providers = [
    BlocProvider<HomeCubit>(
      create: (context) => homeCubit,
    ),
    BlocProvider<ThemeCubit>(
      create: (context) => themeCubit,
    ),
  ];

  Future<void> bootstrap() async {}

  ///Singleton factory
  static final AppCubit instance = AppCubit._internal();

  factory AppCubit() {
    return instance;
  }

  AppCubit._internal();
}
