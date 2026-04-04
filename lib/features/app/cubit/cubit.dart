// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:kim_hue_thao_bank/core/injection/injection_container.dart';
import 'package:kim_hue_thao_bank/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kim_hue_thao_bank/features/home/presentation/cubit/home_cubit.dart';
import 'package:kim_hue_thao_bank/features/theme/presentation/cubit/theme_cubit.dart';

class AppCubit {
  static final HomeCubit homeCubit = getIt<HomeCubit>();
  static final ThemeCubit themeCubit = getIt<ThemeCubit>();
  static final AuthCubit authCubit = getIt<AuthCubit>();

  static final List<BlocProvider> providers = [
    BlocProvider<HomeCubit>(
      create: (context) => homeCubit,
    ),
    BlocProvider<ThemeCubit>(
      create: (context) => themeCubit,
    ),
    BlocProvider<AuthCubit>(
      create: (context) => authCubit,
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
