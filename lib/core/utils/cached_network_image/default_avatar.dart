// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:kht_gold/core/constants/colors_constants.dart';
import 'package:kht_gold/core/constants/constants.dart';
import 'package:kht_gold/core/types/extensions/string_extension.dart';

class DefaultAvatarByText {
  final String keyword;
  final Color backgroundColor;
  final Color textColor;

  DefaultAvatarByText({
    required this.keyword,
    required this.backgroundColor,
    required this.textColor,
  });

  factory DefaultAvatarByText.fromFullName(String? name) {
    final String text;
    if (name?.trim().isEmpty ?? true) {
      text = appName;
    } else {
      text = name ?? appName;
    }

    return DefaultAvatarByText(
      keyword: text.toUpperCase().substring(0, 1),
      backgroundColor: backgroundFromText(
        generateColorFromName(text.substring(0, 1)),
      ),
      textColor: generateColorFromName(text.substring(0, 1)),
    );
  }

  static Color backgroundFromText(Color textColor) {
    final hsl = HSLColor.fromColor(textColor);
    return hsl
        .withLightness((hsl.lightness + 0.25).clamp(0.75, 0.88))
        .toColor();
  }

  static DefaultAvatarByText defaultAvatarConstant = DefaultAvatarByText(
    keyword: 'A',
    backgroundColor: backgroundFromText(generateColorFromName('A')),
    textColor: generateColorFromName('A'),
  );

  static Color generateColorFromName(String? keyword) {
    if (keyword == null || keyword.isEmpty) {
      return ColorsConstants.colorDefault;
    }

    final String lastName = keyword.toUpperCase().formatVietnamese()[0];

    return ColorsConstants.colorByText[lastName] ??
        ColorsConstants.colorDefault;
  }
}
