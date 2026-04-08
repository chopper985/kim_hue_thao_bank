// Package imports:
import 'package:i18n_extension/i18n_extension.dart';

// Project imports:
import 'package:kht_gold/core/app/languages/data/english.dart';
import 'package:kht_gold/core/app/languages/data/vietnamese.dart';

class Strings {
  static const String home = "home";
  static const String language = 'language';
  static const String vietnamese = 'vietnamese';
  static const String english = 'english';
  static const String copied = "copied";
  static const String goldStore = 'goldStore';
  static const String management = 'management';
  static const String settings = 'settings';
  static const String login = 'login';
  static const String loginFailed = 'loginFailed';
  static const String logout = 'logout';
  static const String versionLabel = 'versionLabel';
  static const String selectDate = 'selectDate';
  static const String loadGoldPriceFailed = 'loadGoldPriceFailed';
  static const String emptyGoldPrice = 'emptyGoldPrice';
  static const String lastUpdated = 'lastUpdated';
  static const String goldType = 'goldType';
  static const String buyPrice = 'buyPrice';
  static const String sellPrice = 'sellPrice';
  static const String spread = 'spread';
  static const String username = 'username';
  static const String password = 'password';
}

class MyI18n {
  Map<String, Map<String, String>> get getTranslation => Map.fromEntries(
    vietnamese.keys.map(
      (element) => MapEntry(element, {
        'vi-VN': vietnamese[element]!,
        'en-US': english[element]!,
      }),
    ),
  );
}

extension Localization on String {
  static final _t = Translations.byId('vi-VN', MyI18n().getTranslation);

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(int value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
