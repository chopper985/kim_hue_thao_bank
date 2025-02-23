// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:preny/core/app/languages/service/service.dart';
import 'package:preny/core/app/themes/data/app_themes.dart';
import 'package:preny/core/navigator/app_navigator.dart';
import 'package:preny/core/navigator/app_navigator_observer.dart';
import 'package:preny/core/navigator/app_routes.dart';
import 'package:preny/features/app/cubit/cubit.dart';
import 'package:preny/features/theme/presentation/cubit/theme_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppCubit.providers,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previous, current) {
          if (current is ThemeUpdated && previous is ThemeUpdated) {
            return previous.mode != current.mode;
          }
          return current is ThemeUpdated && previous is! ThemeUpdated;
        },
        builder: (context, theme) {
          return Sizer(
            builder: (context, orientation, deviceType) {
              return MaterialApp(
                title: "Preny",
                navigatorKey: AppNavigator.navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light().data,
                darkTheme: AppTheme.dark().data,
                themeMode: theme is ThemeUpdated ? theme.mode : ThemeMode.light,
                initialRoute: Routes.rootRoute,
                supportedLocales: LanguageService.supportLanguages,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                navigatorObservers: [
                  AppNavigatorObserver(),
                  NavigatorObserver(),
                ],
                onGenerateRoute: (settings) {
                  return AppNavigator().getRoute(settings);
                },
                // builder: (context, child) {
                //   return MediaQuery(
                //     data: MediaQuery.of(context).copyWith(
                //       textScaler: TextScaler.noScaling,
                //     ),
                //     child: Builder(
                //       builder: (context) {
                //         if (Theme.of(context).appBarTheme.systemOverlayStyle !=
                //             null) {
                //           SystemChrome.setSystemUIOverlayStyle(
                //             Theme.of(context).appBarTheme.systemOverlayStyle!,
                //           );
                //         }
                //         return child ?? const SizedBox();
                //       },
                //     ),
                //   );
                // },
              );
            },
          );
        },
      ),
    );
  }
}
