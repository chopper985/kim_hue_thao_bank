import 'package:hive/hive.dart';
import 'package:preny/core/constants/storage_key.dart';
import 'package:preny/core/helpers/path_helper.dart';

class BaseLocalData {
  static Future<void> initialBox() async {
    final String? path = await PathHelper.localStoreDirPreny;
    Hive.init(path);

    await openBoxApp();
  }

  static Future<void> openBoxApp() async {
    await Hive.openBox(StorageKeys.authBox);
    await Hive.openBox(StorageKeys.userBox);
    await Hive.openBox(StorageKeys.language);
  }
}
