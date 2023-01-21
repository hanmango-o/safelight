import 'package:flutter/material.dart';
import 'package:safelight/core/utils/themes.dart';

class SingleChildRoundedCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double? radius;

  const SingleChildRoundedCard({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.width,
    this.height,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(radius ?? SizeTheme.r_sm),
      ),
      padding: padding ?? EdgeInsets.all(SizeTheme.w_sm / 2),
      child: child,
    );
  }
}
