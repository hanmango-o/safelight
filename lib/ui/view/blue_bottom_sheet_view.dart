import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/asset/resource/image_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';
import 'package:safelight/view_model/implement/acoustic_signal_impl.dart';
import 'package:safelight/view_model/implement/test_signal_impl.dart';
import 'package:safelight/view_model/implement/voice_inductor_impl.dart';

class BlueBottomSheetView extends StatefulWidget {
  const BlueBottomSheetView({Key? key}) : super(key: key);

  @override
  State<BlueBottomSheetView> createState() => _BlueBottomSheetViewState();
}

class _BlueBottomSheetViewState extends State<BlueBottomSheetView> {
  final BlueController _blueController = Get.find<BlueController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 1600),
        curve: Curves.fastLinearToSlowEaseIn,
        height: BlueController.isDone.value
            ? ScreenUtil.defaultSize.height.h
            : 96.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(SizeTheme.r_md),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -10),
              blurRadius: 10,
              spreadRadius: 2,
              color: Theme.of(context).colorScheme.background,
            )
          ],
        ),
        child: Column(
          children: [
            AppBar(
              flexibleSpace: Center(
                child: Container(
                  width: 60.w,
                  height: 5.h,
                  margin: EdgeInsets.only(top: 16.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(double.infinity),
                  ),
                ),
              ),
              leading: BlueController.isDone.value
                  ? IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _blueController.blueHandler.reset();
                      },
                    )
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(26.r),
                ),
              ),
              toolbarHeight: 96.h,
              title: Text(
                '내 주변 횡단보도',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: SizeTheme.w_md),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () {
                            switch (BlueController.status.value) {
                              case StatusType.IS_SCANNING:
                                return SizedBox(
                                  width: SizeTheme.h_lg,
                                  height: SizeTheme.h_lg,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                );
                              case StatusType.COMPLETE:
                                return Icon(
                                  Icons.check,
                                  color: ColorTheme.highlight2,
                                  size: SizeTheme.h_lg,
                                );

                              case StatusType.STAND_BY:
                              default:
                                return Icon(
                                  Icons.stop_circle_outlined,
                                  color: ColorTheme.highlight1,
                                  size: SizeTheme.h_lg,
                                );
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: SizeTheme.w_sm),
                          child: Obx(
                            () {
                              switch (BlueController.status.value) {
                                case StatusType.IS_SCANNING:
                                  return Text(
                                    '스캔 중',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .apply(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  );
                                case StatusType.COMPLETE:
                                  return Text(
                                    '스캔 완료',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .apply(color: ColorTheme.highlight2),
                                  );

                                case StatusType.STAND_BY:
                                default:
                                  return Text(
                                    '스캔 대기',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .apply(color: ColorTheme.highlight1),
                                  );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                height: SizeTheme.h_lg,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreamBuilder<List<CrosswalkVO>>(
                        stream: _blueController.blueHandler.results,
                        // stream: Stream.periodic(Duration(seconds: 4)).asyncMap((event) => null),
                        builder: (c, snapshot) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeTheme.w_md,
                            ),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              if (index == snapshot.data?.length) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: SizeTheme.h_lg * 3),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '찾으시는 횡단보도가 없나요?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        SizedBox(height: SizeTheme.h_md),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            _blueController.blueHandler
                                              ..reset()
                                              ..search();
                                          },
                                          icon: const Icon(Icons.search),
                                          label: const Text(
                                            '다시 스캔하기',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return ListTile(
                                onTap: () => showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoActionSheet(
                                      title: const Text('모드 선택'),
                                      actions: [
                                        // CupertinoActionSheetAction(
                                        //   onPressed: () async {
                                        //     Navigator.pop(context);

                                        //     _blueController.blueHandler
                                        //         .sendCMD = VoiceInductor(
                                        //       crosswalks: [
                                        //         snapshot.data![index],
                                        //       ],
                                        //     );
                                        //     _blueController.blueHandler.send();
                                        //     _blueController.blueHandler.reset();
                                        //   },
                                        //   isDefaultAction: true,
                                        //   child: const Text('음성 유도'),
                                        // ),
                                        CupertinoActionSheetAction(
                                          onPressed: () async {
                                            Navigator.pop(context);

                                            // _blueController.blueHandler
                                            //     .sendCMD = AcousticSignal(
                                            //   crosswalks: [
                                            //     snapshot.data![index],
                                            //   ],
                                            // );
                                            _blueController.blueHandler
                                                .sendCMD = TestSignal(
                                              crosswalks: [
                                                snapshot.data![index]
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
                                // onTap: () {
                                //   log('d');
                                //   Get.defaultDialog();
                                //   CupertinoActionSheet(
                                //     title: const Text('주변 압버튼 스캔'),
                                //     message: ElevatedButton(
                                //       onPressed: () {},
                                //       style: ElevatedButton.styleFrom(
                                //         backgroundColor: Theme.of(context)
                                //             .colorScheme
                                //             .secondary,
                                //         foregroundColor: Theme.of(context)
                                //             .colorScheme
                                //             .onSecondary,
                                //       ),
                                //       child: const Text('각 스캔 모드 설명보기'),
                                //     ),
                                //     actions: [
                                //       CupertinoActionSheetAction(
                                //         onPressed: () {
                                //           Navigator.pop(context);
                                //         },
                                //         isDefaultAction: true,
                                //         child: const Text('수동 모드'),
                                //       ),
                                //       CupertinoActionSheetAction(
                                //         onPressed: () {
                                //           Navigator.pop(context);
                                //           Get.snackbar(
                                //             '개발 중입니다.',
                                //             '현재 버전에서는 사용할 수 없습니다.',
                                //           );
                                //         },
                                //         isDefaultAction: true,
                                //         child: const Text('자동 모드'),
                                //       ),
                                //     ],
                                //     cancelButton: CupertinoActionSheetAction(
                                //       isDestructiveAction: true,
                                //       onPressed: () => Navigator.pop(context),
                                //       child: const Text('취소'),
                                //     ),
                                //   );

                                // },
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
                              if (index < snapshot.data!.length - 1) {
                                return const Divider();
                              }
                              return const SizedBox();
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: SizeTheme.h_lg * 3,
                          bottom: SizeTheme.h_lg * 3,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '찾으시는 횡단보도가 없나요?',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(height: SizeTheme.h_md),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _blueController.blueHandler
                                    ..reset()
                                    ..search();
                                },
                                icon: const Icon(Icons.search),
                                label: const Text(
                                  '다시 스캔하기',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
