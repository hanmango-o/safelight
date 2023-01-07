import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safelight/asset/resource/image_resource.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';

class FlatCard extends StatelessWidget {
  Color? backgroundColor;
  String? subTitle;
  String? subLabel;
  String? subTail;
  String title;
  bool bottomTitle;
  Widget? leading;
  Function()? onTap;
  Color? subTitleColor;
  bool titleOnly;
  Widget? trailing;

  FlatCard({
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
    return RichText(
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
    );
  }

  Widget _titleBuilder(BuildContext context) {
    return Text(
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
      trailing: trailing,
    );
  }
}
