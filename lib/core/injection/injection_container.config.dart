// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

// Package imports:
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

// Project imports:
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/theme/presentation/cubit/theme_cubit.dart' as _i5;
import '../utils/datasources/base_repository.dart' as _i961;
import '../utils/dio_api/dio_configuration.dart' as _i721;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i117.AuthCubit>(() => _i117.AuthCubit());
  gh.factory<_i9.HomeCubit>(() => _i9.HomeCubit());
  gh.factory<_i5.ThemeCubit>(() => _i5.ThemeCubit());
  gh.lazySingleton<_i721.DioConfiguration>(() => _i721.DioConfiguration());
  gh.lazySingleton<_i961.BaseRepository>(
    () => _i961.BaseRepository(gh<_i721.DioConfiguration>()),
  );
  return getIt;
}
