import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safelight/core/utils/themes.dart';

class FlatCard extends StatelessWidget {
  final Color? backgroundColor;
  final String? subTitle;
  final String? subLabel;
  final String? subTail;
  final String title;
  final bool bottomTitle;
  final Widget? leading;
  final Function()? onTap;
  final Color? subTitleColor;
  final bool titleOnly;
  final Widget? trailing;

  const FlatCard({
    Key? key,
    this.backgroundColor,
    this.subTitle,
    this.subLabel,
    this.subTail,
    required this.title,
    this.onTap,
    this.leading,
    this.bottomTitle = true,
    this.subTitleColor,
    this.titleOnly = false,
    this.trailing,
  }) : super(key: key);

  Widget _subTitleBuilder(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 90.w),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: RichText(
          text: TextSpan(
            text: subTitle,
            style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: subTitleColor,
                ),
            children: [
              TextSpan(text: subLabel),
              TextSpan(
                text: subTail,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleBuilder(BuildContext context) {
    return AutoSizeText(
      title,
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: backgroundColor,
      contentPadding: EdgeInsets.symmetric(
        vertical: SizeTheme.w_sm,
        horizontal: SizeTheme.h_lg,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          SizeTheme.r_sm,
        ),
      ),
      onTap: onTap,
      leading: leading,
      subtitle: titleOnly
          ? null
          : bottomTitle
              ? _titleBuilder(context)
              : _subTitleBuilder(context),
      title: titleOnly
          ? _titleBuilder(context)
          : bottomTitle
              ? _subTitleBuilder(context)
              : _titleBuilder(context),
      trailing: FittedBox(
        child: trailing,
      ),
    );
  }
}
