// ignore_for_file: avoid_returning_null_for_void

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/frame/board_frame.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';
import 'package:safelight/view_model/implement/default_search_impl.dart';
import 'package:shimmer/shimmer.dart';

import '../../asset/resource/blue_resource.dart';
import '../../asset/resource/image_resource.dart';
import '../../model/vo/crosswalk_vo.dart';
import '../../view_model/implement/acoustic_signal_impl.dart';
import '../../view_model/implement/voice_inductor_impl.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BlueController _blueController = Get.find<BlueController>();

  @override
  void initState() {
    super.initState();
    _blueController.blueHandler.searchCMD = DefaultSearch();
    _blueController.blueHandler
      ..reset()
      ..search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeLight'),
        actions: [
          IconButton(
            onPressed: () => null,
            icon: const Icon(Icons.flashlight_on_outlined),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            color: Colors.white,
            height: 70,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _blueController.blueHandler
                      ..reset()
                      ..search();
                  },
                  icon: const Icon(Icons.navigation_rounded),
                  label: const Text(
                    '보행자 길찾기',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 80.h),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(),
            minimumSize: Size(double.maxFinite, 80.h),
          ),
          onPressed: () async {
            _blueController.blueHandler.searchCMD = DefaultSearch();
            _blueController.blueHandler
              ..reset()
              ..search();
          },
          icon: Obx(
            () {
              switch (BlueController.status.value) {
                case StatusType.IS_SCANNING:
                  return Icon(Icons.stop_circle_outlined);
                case StatusType.COMPLETE:
                  return Icon(Icons.search);
                case StatusType.STAND_BY:
                default:
                  return Icon(Icons.pause_circle_outline);
              }
            },
          ),
          label: Text(
            '횡단보도 압버튼 찾기',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .apply(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            BoardFrame(
              title: '내 주변 횡단보도',
              body: Column(
                children: [
                  StreamBuilder<List<CrosswalkVO>>(
                    stream: _blueController.blueHandler.results,
                    builder: (c, snapshot) {
                      switch (BlueController.status.value) {
                        case StatusType.IS_SCANNING:
                        case StatusType.STAND_BY:
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[350]!,
                            highlightColor: Colors.grey[400]!,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (_, __) => Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeTheme.h_lg,
                                  vertical: SizeTheme.w_sm,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: SizeTheme.w_sm,
                                      ),
                                    ),
                                    Container(
                                      width: 62.w,
                                      height: 62.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(SizeTheme.r_sm),
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 230.w,
                                          height: 16.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(SizeTheme.r_sm),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                        ),
                                        Container(
                                          width: 143.w,
                                          height: 16.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(SizeTheme.r_sm),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              itemCount: 3,
                            ),
                          );

                        case StatusType.COMPLETE:
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeTheme.w_md,
                            ),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: SizeTheme.w_sm,
                                  horizontal: SizeTheme.h_lg,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    SizeTheme.r_sm,
                                  ),
                                ),
                                onTap: () => showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoActionSheet(
                                      title: const Text('모드 선택'),
                                      actions: [
                                        CupertinoActionSheetAction(
                                          onPressed: () async {
                                            Navigator.pop(context);

                                            _blueController.blueHandler
                                                .sendCMD = VoiceInductor(
                                              crosswalks: [
                                                snapshot.data![index],
                                              ],
                                            );
                                            _blueController.blueHandler.send();
                                            _blueController.blueHandler.reset();
                                          },
                                          isDefaultAction: true,
                                          child: const Text('음성 유도'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () async {
                                            Navigator.pop(context);

                                            _blueController.blueHandler
                                                .sendCMD = AcousticSignal(
                                              crosswalks: [
                                                snapshot.data![index],
                                              ],
                                            );

                                            _blueController.blueHandler.send();
                                            _blueController.blueHandler.reset();
                                          },
                                          isDefaultAction: true,
                                          child: const Text('압버튼 누르기'),
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        isDestructiveAction: true,
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('취소'),
                                      ),
                                    );
                                  },
                                ),
                                leading: SingleChildRoundedCard(
                                  child: Image(
                                    width: 42.w,
                                    height: 42.w,
                                    image: AssetImage(
                                      snapshot.data?[index].areaType ==
                                              AreaType.SINGLE_ROAD
                                          ? ImageResource.IMG_TrafficYellow
                                          : ImageResource.IMG_TrafficCross,
                                    ),
                                  ),
                                ),
                                title: RichText(
                                  text: TextSpan(
                                    text: snapshot.data?[index].areaType ==
                                            AreaType.SINGLE_ROAD
                                        ? '황색 점멸등 구간'
                                        : '교차로',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(
                                          color:
                                              snapshot.data?[index].areaType ==
                                                      AreaType.SINGLE_ROAD
                                                  ? ColorTheme.highlight3
                                                  : ColorTheme.highlight1,
                                        ),
                                    children: [
                                      const TextSpan(text: ' '),
                                      TextSpan(
                                        text: snapshot.data?[index].direction ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Text(
                                  snapshot.data?[index].name ?? '',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: SizeTheme.h_sm);
                            },
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 126.h),
          ],
        ),
      ),
    );
  }
}
