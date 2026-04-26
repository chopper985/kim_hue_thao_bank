// Project imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

// Project imports:
import 'package:kht_gold/core/constants/constants.dart';
import 'package:kht_gold/core/navigator/app_router.dart';
import 'package:kht_gold/core/types/extensions/int_extension.dart';

extension StringExtension on String {
  String formatVietnamese() {
    var result = this;
    for (int i = 0; i < vietnameseRegex.length; i++) {
      result = result.replaceAll(
        vietnameseRegex[i],
        i > vietnamese.length - 1 ? '' : vietnamese[i],
      );
    }
    return result;
  }

  void showToast(ToastificationType type) {
    final BuildContext? context = AppRouter.context;
    if (context == null) return;
    final Color? textColor = Theme.of(context).textTheme.bodyMedium?.color;

    toastification.show(
      title: Text(
        this,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 15.5.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      backgroundColor: Theme.of(AppRouter.context!).scaffoldBackgroundColor,
      autoCloseDuration: 2000.milliseconds,
      type: type,
      alignment: Alignment.topCenter,
      style: ToastificationStyle.flat,
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: getColorBorder(type).withValues(alpha: 0.8),
        linearTrackColor: Theme.of(AppRouter.context!).colorScheme.outline,
        borderRadius: BorderRadius.circular(6.sp),
        linearMinHeight: 6.sp,
      ),
      borderSide: BorderSide(color: getColorBorder(type), width: 5.sp),
      closeOnClick: true,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
    );
  }

  Color getColorBorder(ToastificationType type) {
    return type == ToastificationType.error
        ? errorColor
        : type == ToastificationType.warning
        ? warningColor
        : type == ToastificationType.info
        ? infoColor
        : successColor;
  }
}
