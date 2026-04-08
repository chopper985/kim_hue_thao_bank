// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_native_splash/flutter_native_splash.dart';

// Project imports:
import 'package:kim_hue_thao_gold/core/injection/injection_container.dart';
import 'package:kim_hue_thao_gold/core/utils/datasources/base_local_data.dart';

class Application {
  /// [Production - Dev]
  static Future<void> initialAppLication() async {
    try {
      // Config local storage
      await BaseLocalData.initialBox();

      configureDependencies();

      FlutterNativeSplash.remove();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
