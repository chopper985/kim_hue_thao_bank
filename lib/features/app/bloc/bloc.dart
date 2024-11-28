import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preny/core/injection/injection_container.dart';
import 'package:preny/features/home/bloc/home_bloc.dart';

class AppBloc {
  static final HomeCubit homeBloc = getIt<HomeCubit>();

  static final List<BlocProvider> providers = [
    BlocProvider<HomeCubit>(
      create: (context) => homeBloc,
    ),
  ];

  Future<void> bootstrap() async {}

  ///Singleton factory
  static final AppBloc instance = AppBloc._internal();

  factory AppBloc() {
    return instance;
  }

  AppBloc._internal();
}
