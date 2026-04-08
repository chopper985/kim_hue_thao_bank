// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:kht_gold/core/helpers/device_utils.dart';

class ShareUtils {
  Future<void> share({
    String link = 'Link App',
    String title = 'Your App',
    String? description,
  }) async {
    DeviceUtils().lightImpact();

    await SharePlus.instance.share(
      ShareParams(
        text: link,
        subject: title,
        sharePositionOrigin: Rect.fromLTWH(0, 0, 100.w, 10.h),
      ),
    );
  }
}
