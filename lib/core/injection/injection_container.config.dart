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
import '../../features/auth/data/datasources/auth_local_data.dart' as _i612;
import '../../features/auth/data/repositories/auth_repository.dart' as _i824;
import '../../features/auth/domain/usecase/auth_usecase.dart' as _i351;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/home/data/repositories/gold_repository.dart' as _i386;
import '../../features/home/domain/usecase/gold_usecase.dart' as _i789;
import '../../features/home/domain/usecase/index.dart' as _i490;
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
  gh.factory<_i5.ThemeCubit>(() => _i5.ThemeCubit());
  gh.lazySingleton<_i721.DioConfiguration>(() => _i721.DioConfiguration());
  gh.lazySingleton<_i961.BaseRepository>(
    () => _i961.BaseRepository(gh<_i721.DioConfiguration>()),
  );
  gh.lazySingleton<_i612.AuthLocalData>(() => _i612.AuthLocalData());
  gh.lazySingleton<_i824.AuthRepository>(
    () => _i824.AuthRepository(
      gh<_i961.BaseRepository>(),
      gh<_i612.AuthLocalData>(),
    ),
  );
  gh.lazySingleton<_i386.GoldRepository>(
    () => _i386.GoldRepository(gh<_i961.BaseRepository>()),
  );
  gh.lazySingleton<_i351.AuthUsecase>(
    () => _i351.AuthUsecase(gh<_i824.AuthRepository>()),
  );
  gh.lazySingleton<_i789.GoldUsecase>(
    () => _i789.GoldUsecase(gh<_i386.GoldRepository>()),
  );
  gh.factory<_i117.AuthCubit>(() => _i117.AuthCubit(gh<_i351.AuthUsecase>()));
  gh.factory<_i9.HomeCubit>(() => _i9.HomeCubit(gh<_i490.GoldUsecase>()));
  return getIt;
}
