// Dart imports:
import 'dart:core';
import 'dart:ui';

// Project imports:
import 'package:kim_hue_thao_bank/core/constants/colors_constants.dart';
import 'package:kim_hue_thao_bank/core/types/extensions/string_extension.dart';

class DefaultAvatarByText {
  final String keyword;
  final Color backgroundColor;

  DefaultAvatarByText({
    required this.keyword,
    required this.backgroundColor,
  });

  factory DefaultAvatarByText.fromFullName(String name) {
    return DefaultAvatarByText(
      keyword: name.trim().substring(0, 1),
      backgroundColor: generateColorFromName(name.trim().substring(0, 1)),
    );
  }

  static DefaultAvatarByText defaultAvatarConstant = DefaultAvatarByText(
    keyword: 'A',
    backgroundColor: generateColorFromName('A'),
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
