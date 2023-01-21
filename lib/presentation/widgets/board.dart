import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safelight/core/utils/themes.dart';

class Board extends StatelessWidget {
  final String title;
  final Widget body;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? headerPadding;
  final Widget? trailing;
  final TextStyle? titleStyle;
  final double? height;

  const Board({
    Key? key,
    required this.title,
    required this.body,
    this.backgroundColor,
    this.padding,
    this.headerPadding,
    this.trailing,
    this.titleStyle,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        color: backgroundColor,
        padding: padding,
        width: double.infinity,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: headerPadding ??
                    EdgeInsets.symmetric(
                      vertical: SizeTheme.h_sm,
                      horizontal: SizeTheme.w_md,
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 180.w),
                      child: FittedBox(
                        child: Text(
                          title,
                          style: titleStyle ??
                              Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 60.w),
                      child: trailing ?? FittedBox(child: trailing),
                    ),
                  ],
                ),
              ),
            ),
            body,
          ],
        ),
      ),
    );
  }
}
