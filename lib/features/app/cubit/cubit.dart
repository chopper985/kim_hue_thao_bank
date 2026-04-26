// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:kht_gold/core/injection/injection_container.dart';
import 'package:kht_gold/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kht_gold/features/home/presentation/cubit/home_cubit.dart';
import 'package:kht_gold/features/management/presentation/cubit/management_cubit.dart';
import 'package:kht_gold/features/theme/presentation/cubit/theme_cubit.dart';

class AppCubit {
  static final HomeCubit homeCubit = getIt<HomeCubit>();
  static final ThemeCubit themeCubit = getIt<ThemeCubit>();
  static final AuthCubit authCubit = getIt<AuthCubit>();
  static final ManagementCubit managementCubit = getIt<ManagementCubit>();

  static final List<BlocProvider> providers = [
    BlocProvider<HomeCubit>(create: (context) => homeCubit),
    BlocProvider<ThemeCubit>(create: (context) => themeCubit),
    BlocProvider<AuthCubit>(create: (context) => authCubit),
    BlocProvider<ManagementCubit>(create: (context) => managementCubit),
  ];

  Future<void> bootstrap() async {}

  ///Singleton factory
  static final AppCubit instance = AppCubit._internal();

  factory AppCubit() {
    return instance;
  }

  AppCubit._internal();
}
