// Package imports:
import 'package:hive_ce/hive.dart';

// Project imports:
import 'package:kim_hue_thao_gold/core/constants/storage_key.dart';

class ThemeLocalData {
  final Box hiveBox = Hive.box(StorageKeys.theme);

  int get indexOfThemeMode {
    return hiveBox.get(StorageKeys.theme) ?? 0;
  }

  void saveIndexOfThemeMode(int index) {
    hiveBox.put(StorageKeys.theme, index);
  }
}
