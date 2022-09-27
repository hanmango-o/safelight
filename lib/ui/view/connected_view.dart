import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/ui/frame/board_frame.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';

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
      body: BoardFrame(
        title: '편의 기능',
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeTheme.w_md,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(SizeTheme.w_sm),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeTheme.r_md),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        // await _blueController.services(
                        //   ServiceType.SEARCH_BY_DIRECTION_OF_VIEW,
                        // );
                      },
                      title: Text('바라보는 방향 기준'),
                      subtitle: Text('압버튼 찾기'),
                      leading: SingleChildRoundedCard(
                        child: Icon(
                          Icons.play_circle_outline_rounded,
                          size: 32.sp,
                          color: ColorTheme.highlight1,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () async {
                        // await _blueController.services(
                        //   ServiceType
                        //       .CONNECT_ALL_IMMEDIATELY_AFTER_SEARCH,
                        // );
                      },
                      title: Text('압버튼 스캔 후'),
                      subtitle: Text('모두 누르기'),
                      leading: SingleChildRoundedCard(
                        child: Icon(
                          Icons.radio_button_checked_rounded,
                          size: 32.sp,
                          color: ColorTheme.highlight2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
