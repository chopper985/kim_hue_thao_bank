import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:preny/core/navigator/app_navigator.dart';
import 'package:sizer/sizer.dart';

AppBar appBarTitleBack(
  BuildContext context, {
  String title = '',
  List<Widget>? actions,
  Function()? onBackPressed,
  Color? backgroundColor,
  Brightness? brightness,
  double? paddingLeft,
  Color? colorChild,
  PreferredSizeWidget? bottom,
  Widget? titleWidget,
  Widget? leading,
  double? elevation,
  double? leadingWidth,
  bool centerTitle = true,
  bool isVisibleBackButton = true,
  double? titleSpacing,
  double? titleTextSize,
  double? toolbarHeight,
}) {
  return AppBar(
    toolbarHeight: toolbarHeight,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: (brightness ?? Theme.of(context).brightness) ==
              (Platform.isAndroid ? Brightness.dark : Brightness.light)
          ? Brightness.light
          : Brightness.dark,
      statusBarIconBrightness: (brightness ?? Theme.of(context).brightness) ==
              (Platform.isAndroid ? Brightness.dark : Brightness.light)
          ? Brightness.light
          : Brightness.dark,
    ),
    elevation: elevation ?? 0.0,
    backgroundColor: backgroundColor ?? Colors.transparent,
    automaticallyImplyLeading: false,
    centerTitle: centerTitle,
    leadingWidth: leadingWidth ?? 30.sp,
    titleSpacing: titleSpacing,
    title: titleWidget ??
        Text(
          title,
          maxLines: 2,
          style: TextStyle(
            fontSize: titleTextSize ?? 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
    leading: !isVisibleBackButton || !AppNavigator.canPop
        ? null
        : leading ??
            GestureDetector(
              onTap: () {
                if (onBackPressed != null) {
                  onBackPressed();
                } else {
                  AppNavigator.pop();
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: paddingLeft ?? 3.sp),
                child: Icon(
                  PhosphorIcons.caretLeft(),
                  size: 20.sp,
                  color: colorChild,
                ),
              ),
            ),
    actions: actions,
    bottom: bottom,
  );
}
