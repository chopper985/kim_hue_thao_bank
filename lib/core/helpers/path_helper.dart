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

  static Future<void> createDirkim_hue_thao_bank() async {
    if (kIsWeb) return;

    final String? tempkim_hue_thao_bankDir = await tempDirkim_hue_thao_bank;
    final String? localStorekim_hue_thao_bankDir =
        await localStoreDirkim_hue_thao_bank;
    if (tempkim_hue_thao_bankDir == null ||
        localStorekim_hue_thao_bankDir == null) return;

    final Directory myDir = Directory(tempkim_hue_thao_bankDir);
    final Directory localDir = Directory(localStorekim_hue_thao_bankDir);
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

  static Future<String?> get tempDirkim_hue_thao_bank async {
    if (kIsWeb) return null;

    return '${(await getTemporaryDirectory()).path}/kim_hue_thao_bank';
  }

  static Future<String?> get localStoreDirkim_hue_thao_bank async {
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
    final String? tempkim_hue_thao_bankDir = await tempDirkim_hue_thao_bank;

    if (tempkim_hue_thao_bankDir == null) return 0;

    final Directory myDir = Directory(tempkim_hue_thao_bankDir);

    if (!myDir.existsSync()) return 0;

    return myDir.listSync().isEmpty ? 0 : ((myDir.statSync().size - 64) * 1024);
  }

  static Future<void> clearTempDir() async {
    final String? tempkim_hue_thao_bankDir = await tempDirkim_hue_thao_bank;

    if (tempkim_hue_thao_bankDir == null) return;

    final Directory myDir = Directory(tempkim_hue_thao_bankDir);

    if (!myDir.existsSync()) return;

    myDir.deleteSync(recursive: true);
    myDir.create();
  }
}
