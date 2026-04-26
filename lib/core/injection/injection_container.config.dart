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
import '../../features/auth/data/datasources/auth_local_data.dart' as _i408;
import '../../features/auth/data/repositories/auth_repository.dart' as _i573;
import '../../features/auth/domain/usecase/auth_usecase.dart' as _i676;
import '../../features/auth/domain/usecase/index.dart' as _i231;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/home/data/repositories/gold_repository.dart' as _i386;
import '../../features/home/domain/usecase/index.dart' as _i490;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/theme/presentation/cubit/theme_cubit.dart' as _i5;
import '../utils/datasources/base_repository.dart' as _i961;
import '../utils/dio_api/dio_configuration.dart' as _i721;

import '../../features/home/domain/usecase/create_gold_type_usecase.dart'
    as _i712;
import '../../features/home/domain/usecase/get_gold_types_usecase.dart'
    as _i460;
import '../../features/home/domain/usecase/get_price_board_usecase.dart'
    as _i26;
import '../../features/home/domain/usecase/update_gold_prices_usecase.dart'
    as _i364;
import '../../features/home/domain/usecase/update_gold_types_usecase.dart'
    as _i632;
import '../../features/management/presentation/cubit/management_cubit.dart'
    as _i545;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i5.ThemeCubit>(() => _i5.ThemeCubit());
  gh.lazySingleton<_i721.DioConfiguration>(() => _i721.DioConfiguration());
  gh.lazySingleton<_i408.AuthLocalData>(() => _i408.AuthLocalDataImpl());
  gh.lazySingleton<_i961.BaseRepository>(
    () => _i961.BaseRepository(
      gh<_i408.AuthLocalData>(),
      gh<_i721.DioConfiguration>(),
    ),
  );
  gh.lazySingleton<_i386.GoldRepository>(
    () => _i386.GoldRepository(gh<_i961.BaseRepository>()),
  );
  gh.lazySingleton<_i573.AuthRepository>(
    () => _i573.AuthRepository(
      gh<_i961.BaseRepository>(),
      gh<_i408.AuthLocalData>(),
    ),
  );
  gh.lazySingleton<_i712.CreateGoldTypeUsecase>(
    () => _i712.CreateGoldTypeUsecase(gh<_i386.GoldRepository>()),
  );
  gh.lazySingleton<_i460.GetGoldTypesUsecase>(
    () => _i460.GetGoldTypesUsecase(gh<_i386.GoldRepository>()),
  );
  gh.lazySingleton<_i26.GetPriceBoardUsecase>(
    () => _i26.GetPriceBoardUsecase(gh<_i386.GoldRepository>()),
  );
  gh.lazySingleton<_i364.UpdateGoldPricesUsecase>(
    () => _i364.UpdateGoldPricesUsecase(gh<_i386.GoldRepository>()),
  );
  gh.lazySingleton<_i632.UpdateGoldTypesUsecase>(
    () => _i632.UpdateGoldTypesUsecase(gh<_i386.GoldRepository>()),
  );
  gh.factory<_i9.HomeCubit>(
    () => _i9.HomeCubit(gh<_i490.GetPriceBoardUsecase>()),
  );
  gh.lazySingleton<_i676.AuthUsecase>(
    () => _i676.AuthUsecase(gh<_i573.AuthRepository>()),
  );
  gh.lazySingleton<_i545.ManagementCubit>(
    () => _i545.ManagementCubit(
      gh<_i490.GetGoldTypesUsecase>(),
      gh<_i490.GetPriceBoardUsecase>(),
      gh<_i490.CreateGoldTypeUsecase>(),
      gh<_i490.UpdateGoldTypesUsecase>(),
      gh<_i490.UpdateGoldPricesUsecase>(),
    ),
  );
  gh.factory<_i117.AuthCubit>(() => _i117.AuthCubit(gh<_i231.AuthUsecase>()));
  return getIt;
}
