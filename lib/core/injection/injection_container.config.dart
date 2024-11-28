// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/cubit/auth_cubit.dart' as _i698;
import '../../features/home/cubit/home_cubit.dart' as _i1032;
import '../../features/theme/cubit/theme_cubit.dart' as _i713;
import '../utils/datasources/base_repository.dart' as _i961;
import '../utils/dio_api/dio_configuration.dart' as _i721;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i1032.HomeCubit>(() => _i1032.HomeCubit());
  gh.factory<_i698.AuthCubit>(() => _i698.AuthCubit());
  gh.factory<_i713.ThemeCubit>(() => _i713.ThemeCubit());
  gh.lazySingleton<_i721.DioConfiguration>(() => _i721.DioConfiguration());
  gh.lazySingleton<_i961.BaseRepository>(
      () => _i961.BaseRepository(gh<_i721.DioConfiguration>()));
  return getIt;
}
