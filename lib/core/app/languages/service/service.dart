// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:kim_hue_thao_gold/core/app/languages/service/lang_local.dart';
import 'package:kim_hue_thao_gold/core/app/languages/service/model.dart';

class LanguageService {
  static List<Locale> supportLanguages = [
    const Locale("en"),
    const Locale("vi"),
    const Locale("da"),
    const Locale("de"),
    const Locale("el"),
    const Locale("fr"),
    const Locale("id"),
    const Locale("ja"),
    const Locale("ko"),
    const Locale("nl"),
    const Locale("zh"),
    const Locale("ru"),
  ];

  void saveLocale(String langCode) {
    LanguagesLocalData().setLocale(langCode: langCode);
  }

  Language getLocale() {
    final String? langCode = LanguagesLocalData().getLocale();
    switch (langCode) {
      case "en":
        return Language.english;
      case 'vi':
        return Language.vietnam;
      default:
        return Language.english; // default
    }
  }

  bool getIsLanguage(String locale) {
    return LanguagesLocalData().getLocale() == locale;
  }
}
