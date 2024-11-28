import 'package:hive/hive.dart';
import 'package:preny/core/constants/storage_key.dart';

class LanguagesLocalData {
  final Box hiveBox = Hive.box(StorageKeys.language);

  void setLocale({required String langCode}) {
    hiveBox.put(
      StorageKeys.language,
      langCode,
    );
  }

  String? getLocale() {
    return hiveBox.get(StorageKeys.language);
  }
}
