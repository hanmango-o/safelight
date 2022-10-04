import 'package:flutter/material.dart';

class FlatCard extends StatelessWidget {
  final bool isVertical;
  final String title;
  final List<Widget> actions;
  final Widget leading;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget? header;
  final EdgeInsets? headerPadding;
  final Widget? body;
  final EdgeInsets? bodyPadding;
  final Widget? footer;
  final EdgeInsets? footerPadding;

  const FlatCard({
    Key? key,
    this.isVertical = true,
    this.title = '',
    this.actions = const <Widget>[],
    this.leading = const CircleAvatar(),
    this.margin,
    this.padding,
    this.header,
    this.headerPadding,
    this.body,
    this.bodyPadding,
    this.footer,
    this.footerPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 20.0),
        padding: padding ?? const EdgeInsets.all(10.0),
        color: Theme.of(context).colorScheme.primaryContainer,
        width: double.infinity,
        child: isVertical
            ? Column(
                children: [
                  Padding(
                    padding: headerPadding ?? EdgeInsets.zero,
                    child: header ??
                        ConstrainedBox(
                          constraints: const BoxConstraints(),
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                  ),
                  Padding(
                    padding: bodyPadding ?? EdgeInsets.zero,
                    child: body,
                  ),
                  Padding(
                    padding: footerPadding ?? EdgeInsets.zero,
                    child: footer,
                  )
                ],
              )
            : Row(
                children: [
                  Padding(
                    padding: headerPadding ?? EdgeInsets.zero,
                    child: header ?? leading,
                  ),
                  Padding(
                    padding: bodyPadding ?? EdgeInsets.zero,
                    child: body,
                  ),
                  Padding(
                    padding: footerPadding ?? EdgeInsets.zero,
                    child: footer ?? Row(children: actions),
                  )
                ],
              ),
      ),
    );
  }
}
