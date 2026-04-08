// Package imports:
import 'package:hive_ce/hive.dart';

// Project imports:
import 'package:kht_gold/core/constants/storage_key.dart';
import 'package:kht_gold/core/helpers/path_helper.dart';

class BaseLocalData {
  static Future<void> initialBox() async {
    final String? path = await PathHelper.localStoreDirkht_gold;
    Hive.init(path);

    await openBoxApp();
  }

  static Future<void> openBoxApp() async {
    await Hive.openBox(StorageKeys.authBox);
    await Hive.openBox(StorageKeys.userBox);
    await Hive.openBox(StorageKeys.language);
  }
}
