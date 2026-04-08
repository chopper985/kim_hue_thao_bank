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
}

class MyI18n {
  Map<String, Map<String, String>> get getTranslation => Map.fromEntries(
        vietnamese.keys.map(
          (element) => MapEntry(
            element,
            {'vi_vn': vietnamese[element]!, 'en_us': english[element]!},
          ),
        ),
      );
}

extension Localization on String {
  static final _t = Translations.byId('vi_vn', MyI18n().getTranslation);

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(int value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
