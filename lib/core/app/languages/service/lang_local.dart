// Package imports:
import 'package:hive_ce/hive.dart';

// Project imports:
import 'package:kht_gold/core/constants/storage_key.dart';

class LanguagesLocalData {
  final Box hiveBox = Hive.box(StorageKeys.language);

  void setLocale({required String langCode}) {
    hiveBox.put(StorageKeys.language, langCode);
  }

  String? getLocale() {
    return hiveBox.get(StorageKeys.language);
  }
}
