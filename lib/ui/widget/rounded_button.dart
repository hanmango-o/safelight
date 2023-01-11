import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safelight/asset/static/size_theme.dart';

class RoundedButton extends StatelessWidget {
  final Function() onTap;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final String title;
  final List<Widget>? actions;

  const RoundedButton({
    Key? key,
    required this.onTap,
    required this.title,
    this.backgroundColor,
    this.padding,
    this.actions = const <Widget>[],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FittedBox(
        child: Container(
          padding: padding ??
              EdgeInsets.symmetric(
                vertical: SizeTheme.h_lg * 2,
                horizontal: SizeTheme.w_lg,
              ),
          constraints: BoxConstraints(
            minWidth: 173.w,
            // maxWidth: 173.w,
            minHeight: 208.h,
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(SizeTheme.r_lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 수정 필요