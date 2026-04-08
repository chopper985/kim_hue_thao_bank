// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:path_provider/path_provider.dart';

class PathHelper {
  static Future<void> deleteCacheImageDir(String path) async {
    final cacheDir = Directory(path);
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  static Future<void> createDirkht_gold() async {
    if (kIsWeb) return;

    final String? tempkht_goldDir = await tempDirkht_gold;
    final String? localStorekht_goldDir = await localStoreDirkht_gold;
    if (tempkht_goldDir == null || localStorekht_goldDir == null) return;

    final Directory myDir = Directory(tempkht_goldDir);
    final Directory localDir = Directory(localStorekht_goldDir);
    final Directory? appDirectory = await appDir;

    if (!myDir.existsSync()) {
      await myDir.create();
    }

    if (!localDir.existsSync()) {
      await localDir.create();
    }

    if (appDirectory != null && !appDirectory.existsSync()) {
      await appDirectory.create();
    }
  }

  static Future<String?> get tempDirkht_gold async {
    if (kIsWeb) return null;

    return '${(await getTemporaryDirectory()).path}/kht_gold';
  }

  static Future<String?> get localStoreDirkht_gold async {
    if (kIsWeb) return null;

    return '${(await getTemporaryDirectory()).path}/hive';
  }

  static Future<Directory?> get appDir async {
    if (kIsWeb) return null;

    return await getApplicationDocumentsDirectory();
  }

  static Future<Directory?> get downloadsDir async {
    Directory downloadsDirectory;
    try {
      if (Platform.isIOS) {
        downloadsDirectory = await getLibraryDirectory();
      } else {
        downloadsDirectory = await getApplicationSupportDirectory();
      }

      return downloadsDirectory;
    } on PlatformException {
      return null;
    }
  }

  static Future<int> getTempSize() async {
    final String? tempkht_goldDir = await tempDirkht_gold;

    if (tempkht_goldDir == null) return 0;

    final Directory myDir = Directory(tempkht_goldDir);

    if (!myDir.existsSync()) return 0;

    return myDir.listSync().isEmpty ? 0 : ((myDir.statSync().size - 64) * 1024);
  }

  static Future<void> clearTempDir() async {
    final String? tempkht_goldDir = await tempDirkht_gold;

    if (tempkht_goldDir == null) return;

    final Directory myDir = Directory(tempkht_goldDir);

    if (!myDir.existsSync()) return;

    myDir.deleteSync(recursive: true);
    myDir.create();
  }
}
