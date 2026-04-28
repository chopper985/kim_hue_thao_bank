// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:kht_gold/core/app/styles/app_style_colors.dart';

class TextWithObligatory extends StatelessWidget {
  final String title;
  final bool isObligatory;
  final double? textSize;
  final TextStyle? textStyle;
  final int? maxLine;
  final EdgeInsetsGeometry? padding;

  const TextWithObligatory({
    super.key,
    required this.title,
    this.isObligatory = true,
    this.textSize,
    this.textStyle,
    this.padding,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(left: 4.sp),
      child: Row(
        children: [
          RichText(
            maxLines: maxLine ?? 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style:
                  textStyle ??
                  TextStyle(
                    color: AppStyleColors.textPrimary,
                    fontWeight: .w700,
                    fontSize: 16.sp,
                  ),
              children: [
                TextSpan(text: title),
                WidgetSpan(child: SizedBox(width: 6.sp)),
                if (isObligatory)
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
