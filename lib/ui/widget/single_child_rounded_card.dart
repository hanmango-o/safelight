import 'package:flutter/material.dart';
import 'package:safelight/asset/static/size_theme.dart';

class SingleChildRoundedCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const SingleChildRoundedCard({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(SizeTheme.r_sm),
      ),
      padding: padding ?? EdgeInsets.all(SizeTheme.w_sm / 2),
      child: child,
    );
  }
}
