// Flutter imports:
import 'package:flutter/material.dart';
import 'package:kht_gold/core/app/colors/app_colors.dart';
import 'package:kht_gold/core/utils/cached_network_image/default_avatar.dart';
import 'package:kht_gold/gen/assets.gen.dart';

// Package imports:
import 'package:sizer/sizer.dart';

class DefaultImage extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;
  final Widget? childInAvatar;
  final DefaultAvatarByText? defaultAvatar;
  final BoxBorder? border;
  const DefaultImage({
    super.key,
    required this.height,
    required this.width,
    this.margin,
    required this.shape,
    this.borderRadius,
    this.childInAvatar,
    this.defaultAvatar,
    this.border,
  });
  @override
  Widget build(BuildContext context) {
    return defaultAvatar == null
        ? Container(
            height: height,
            width: width,
            margin: margin,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? fCD
                  : mCU,
            ),
            child: Center(
              child: Image.asset(
                Assets.icons.icKhtGold.path,
                width: 30.sp,
                height: 30.sp,
                color: Theme.of(context).brightness == Brightness.dark
                    ? mGD
                    : mGB,
              ),
            ),
          )
        : Container(
            height: height,
            width: width,
            margin: margin,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      color: defaultAvatar!.backgroundColor,
                      shape: shape,
                      border: border,
                    ),
                    alignment: Alignment.bottomRight,
                    child: childInAvatar,
                  ),
                ),
                if (defaultAvatar != null)
                  Text(
                    defaultAvatar!.keyword,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width / 2,
                      fontWeight: FontWeight.w700,
                      color: defaultAvatar!.textColor,
                    ),
                  ),
              ],
            ),
          );
  }
}
