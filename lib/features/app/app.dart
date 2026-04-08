// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:kht_gold/core/app/languages/service/service.dart';
import 'package:kht_gold/core/app/themes/data/app_themes.dart';
import 'package:kht_gold/core/navigator/app_router.dart';
import 'package:kht_gold/features/app/cubit/cubit.dart';
import 'package:kht_gold/features/theme/presentation/cubit/theme_cubit.dart';

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
              return MaterialApp.router(
                title: "KHT Bank",
                routerConfig: AppRouter.instance.router,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light().data,
                darkTheme: AppTheme.dark().data,
                themeMode: theme is ThemeUpdated ? theme.mode : ThemeMode.light,
                supportedLocales: LanguageService.supportLanguages,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              );
            },
          );
        },
      ),
    );
  }
}
