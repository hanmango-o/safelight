import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';

class ConnectedView extends StatefulWidget {
  final CrosswalkVO crosswalk;

  const ConnectedView({Key? key, required this.crosswalk}) : super(key: key);

  @override
  State<ConnectedView> createState() => _ConnectedViewState();
}

class _ConnectedViewState extends State<ConnectedView> {
  @override
  void dispose() {
    super.dispose();
    widget.crosswalk.post.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: widget.crosswalk.areaType == AreaType.SINGLE_ROAD
                    ? '황색 점멸등 구간'
                    : '교차로',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: widget.crosswalk.areaType == AreaType.SINGLE_ROAD
                          ? ColorTheme.highlight3
                          : ColorTheme.highlight1,
                    ),
                children: [
                  TextSpan(text: ' '),
                  TextSpan(
                    text: widget.crosswalk.direction ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(widget.crosswalk.name),
          ],
        ),
      ),
      body: ElevatedButton(
        child: Text('d'),
        onPressed: () {
          // print(Get.arguments['post']);
          // Get.arguments['post'].disconnect();
        },
      ),
    );
  }
}
