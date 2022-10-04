import 'package:flutter/material.dart';
import 'package:safelight/asset/static/size_theme.dart';

class BoardFrame extends StatelessWidget {
  final String title;
  final Widget body;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? headerPadding;

  const BoardFrame({
    Key? key,
    required this.title,
    required this.body,
    this.backgroundColor,
    this.padding,
    this.headerPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        color: backgroundColor,
        padding: padding,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: headerPadding ??
                  EdgeInsets.symmetric(
                    vertical: SizeTheme.h_sm,
                    horizontal: SizeTheme.w_md,
                  ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            body,
          ],
        ),
      ),
    );
  }
}
