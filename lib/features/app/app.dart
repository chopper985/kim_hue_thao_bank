import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preny/core/app/languages/service/service.dart';
import 'package:preny/core/navigator/app_navigator.dart';
import 'package:preny/core/navigator/app_navigator_observer.dart';
import 'package:preny/core/navigator/app_routes.dart';
import 'package:preny/features/app/bloc/bloc.dart';
import 'package:sizer/sizer.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: "Preny",
            navigatorKey: AppNavigator.navigatorKey,
            debugShowCheckedModeBanner: false,
            // theme: AppTheme.light(colorSeed: ).data,
            // darkTheme: AppTheme.dark(colorSeed: theme.props.last).data,
            themeMode: ThemeMode.dark,
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
      ),
    );
  }
}
