// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:toastification/toastification.dart';

// Project imports:
import 'package:kht_gold/core/app/application/application.dart';
import 'package:kht_gold/core/app/languages/service/service.dart';
import 'package:kht_gold/features/app/app.dart';

Future<void> main() async {
  await runZoned(
    () async {
      final WidgetsBinding widgetsBinding =
          WidgetsFlutterBinding.ensureInitialized();
      // Keep native splash screen up until app is finished bootstrapping
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );

      await Application.initialAppLication();

      runApp(
        I18n(
          initialLocale: LanguageService().getLocale().locale,
          child: const ToastificationWrapper(child: App()),
        ),
      );
    },
    // (error, stackTrack) {
    //   debugPrint("stackTrack $error");
    // },
  );
}
