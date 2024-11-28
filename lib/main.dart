import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:preny/features/app/app.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      final WidgetsBinding widgetsBinding =
          WidgetsFlutterBinding.ensureInitialized();
      // Keep native splash screen up until app is finished bootstrapping
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      runApp(const MyApp());
    },
    (error, stackTrack) {},
  );
}
