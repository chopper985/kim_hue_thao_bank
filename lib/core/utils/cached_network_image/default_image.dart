// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:AppName/core/utils/cached_network_image/default_avatar.dart';
import 'package:AppName/gen/assets.gen.dart';

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
    return Container(
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
              decoration: defaultAvatar != null
                  ? BoxDecoration(
                      color: defaultAvatar!.backgroundColor,
                      shape: shape,
                      border: border,
                    )
                  : BoxDecoration(
                      shape: shape,
                      border: border,
                      borderRadius: borderRadius,
                      image: DecorationImage(
                        image: AssetImage(Assets.icons.icLauncherIos.path),
                        fit: shape == BoxShape.circle
                            ? BoxFit.fitHeight
                            : BoxFit.contain,
                      ),
                    ),
              alignment: Alignment.bottomRight,
              child: childInAvatar,
            ),
          ),
          defaultAvatar == null
              ? const SizedBox()
              : Text(
                  defaultAvatar!.keyword,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width / 2.85,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
    );
  }
}
