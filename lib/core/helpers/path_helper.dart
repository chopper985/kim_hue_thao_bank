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

  static Future<void> createDirAppName() async {
    if (kIsWeb) return;

    final String? tempAppNameDir = await tempDirAppName;
    final String? localStoreAppNameDir = await localStoreDirAppName;
    if (tempAppNameDir == null || localStoreAppNameDir == null) return;

    final Directory myDir = Directory(tempAppNameDir);
    final Directory localDir = Directory(localStoreAppNameDir);
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

  static Future<String?> get tempDirAppName async {
    if (kIsWeb) return null;

    return '${(await getTemporaryDirectory()).path}/AppName';
  }

  static Future<String?> get localStoreDirAppName async {
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
    final String? tempAppNameDir = await tempDirAppName;

    if (tempAppNameDir == null) return 0;

    final Directory myDir = Directory(tempAppNameDir);

    if (!myDir.existsSync()) return 0;

    return myDir.listSync().isEmpty ? 0 : ((myDir.statSync().size - 64) * 1024);
  }

  static Future<void> clearTempDir() async {
    final String? tempAppNameDir = await tempDirAppName;

    if (tempAppNameDir == null) return;

    final Directory myDir = Directory(tempAppNameDir);

    if (!myDir.existsSync()) return;

    myDir.deleteSync(recursive: true);
    myDir.create();
  }
}
