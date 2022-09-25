import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/image_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';

class BlueBottomSheetView extends StatefulWidget {
  const BlueBottomSheetView({Key? key}) : super(key: key);

  @override
  State<BlueBottomSheetView> createState() => _BlueBottomSheetViewState();
}

class _BlueBottomSheetViewState extends State<BlueBottomSheetView> {
  final BlueController _blueController = Get.find<BlueController>();

  List testElement = [
    {
      'type': 0,
      'leading': 'A교차로',
      'direction': 'xx방면 yy방향',
      'name': 'B 횡단보도',
    },
    {
      'type': 1,
      'leading': null,
      'direction': 'aa방면 bb방향',
      'name': 'C 횡단보도',
    },
  ];

  // var a = ScanResult{'device': BluetoothDevice{'id': '5FCB86D0-3318-B901-42F0-1A7E7EAE9BB6', 'name': 'HMSoft', 'type': BluetoothDeviceType.le, 'isDiscoveringServices': false, '_services': [], 'advertisementData': AdvertisementData{'localName': 'HMSoft', 'txPowerLevel': null, 'connectable': true, 'manufacturerData': {19784: [176, 16, 160, 116, 247, 29]}, 'serviceData': {'B000': [0, 0, 0, 0]}, 'serviceUuids': ['FFE3']}, 'rssi': -50};

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 1600),
      curve: Curves.fastLinearToSlowEaseIn,
      height: _blueController.isOpened ? ScreenUtil.defaultSize.height.h : 96.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SizeTheme.r_md),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -10),
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
            leading: _blueController.isOpened
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _blueController.isOpened = !_blueController.isOpened;
                      });
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
                      SizedBox(
                        width: 15.w,
                        height: 15.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(width: SizeTheme.w_sm),
                      Text(
                        '스캔 중',
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                            color: Theme.of(context).colorScheme.primary),
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
              child: StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                // stream: Stream.periodic(Duration(seconds: 4)).asyncMap((event) => null),
                builder: (c, snapshot) {
                  if (snapshot.data?.isEmpty == true) {
                    return SingleChildScrollView(
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
                              onPressed: () => null,
                              icon: Icon(Icons.search),
                              label: Text(
                                '다시 스캔하기',
                              ),
                              style: ElevatedButton.styleFrom(
                                primary:
                                    Theme.of(context).colorScheme.background,
                                onPrimary:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // log(snapshot.data.toString());
                    log(snapshot.data.toString());
                    print(snapshot.data?.length ?? -1 + 1);
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: SizeTheme.w_md),
                      itemCount: snapshot.data?.length ?? -1 + 1,
                      itemBuilder: (context, index) {
                        if (index == testElement.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: SizeTheme.h_lg * 3),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '찾으시는 횡단보도가 없나요?',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  SizedBox(height: SizeTheme.h_md),
                                  ElevatedButton.icon(
                                    onPressed: () => null,
                                    icon: Icon(Icons.search),
                                    label: Text(
                                      '다시 스캔하기',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      onPrimary: Theme.of(context)
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
                          leading: SingleChildRoundedCard(
                            // padding: EdgeInsets.all(SizeTheme.w_sm),
                            child: Image(
                              width: 42.w,
                              height: 42.w,
                              image: AssetImage(ImageResource.IMG_TrafficCross),
                              // image: AssetImage(
                              //   testElement[index]['type'] == 0
                              //       ? ImageResource.IMG_TrafficCross
                              //       : ImageResource.IMG_TrafficYellow,
                              // ),
                            ),
                          ),
                          title: RichText(
                            text: TextSpan(
                              text: '황색 점멸등 구간',
                              // text: testElement[index]['type'] == 0
                              //     ? testElement[index]['leading']
                              //     : '황색 점멸등 구간',
                              style:
                                  Theme.of(context).textTheme.bodyMedium!.apply(
                                      // color: testElement[index]['type'] == 0
                                      //     ? ColorTheme.highlight3
                                      //     : ColorTheme.highlight1,
                                      ),
                              children: [
                                TextSpan(text: ' '),
                                TextSpan(
                                  // text: testElement[index]['direction'],
                                  text: 'xxx방면',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(
                            // testElement[index]['name'],
                            'ㅇㅇㅇ',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        if (index < testElement.length - 1) {
                          return Divider();
                        }
                        return SizedBox();
                      },
                    );
                  }

                  // return ListView.separated(
                  //   itemCount: 2,
                  //   itemBuilder: (context, index) {
                  //     return ListTile();
                  //   },
                  //   separatorBuilder: (context, index) {
                  //     return Divider();
                  //   },
                  // );

                  // 해당 부분 BLE와 테스트 해보아야 함

                  // return Column(
                  //   children: snapshot.data!.map((r) {
                  //     if (r.device.name == 'HMSoft') {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(20.0),
                  //         child: SizedBox(
                  //           width: double.infinity,
                  //           height: 60,
                  //           child: ElevatedButton(
                  //             child: Text(
                  //               '역곡역 1번출구 방향 압버튼',
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //             onPressed: (r.advertisementData.connectable)
                  //                 ? () async {
                  //                     await r.device.connect(autoConnect: true);
                  //                     Get.to(() =>
                  //                         PressedBtnView(device: r.device));
                  //                   }
                  //                 : null,
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //     return SizedBox();
                  //   }).toList(),
                  // );
                  // if (snapshot.data!.isEmpty) {
                  //   return SingleChildScrollView(
                  //     child: Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             '찾으시는 횡단보도가 없나요?',
                  //             style: Theme.of(context).textTheme.bodySmall,
                  //           ),
                  //           SizedBox(height: SizeTheme.h_md),
                  //           ElevatedButton.icon(
                  //             onPressed: () => null,
                  //             icon: Icon(Icons.search),
                  //             label: Text(
                  //               '다시 스캔하기',
                  //             ),
                  //             style: ElevatedButton.styleFrom(
                  //               primary:
                  //                   Theme.of(context).colorScheme.background,
                  //               onPrimary:
                  //                   Theme.of(context).colorScheme.onSecondary,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   );
                  // }
                  // return SizedBox();
                  // return ListView.separated(
                  //   padding: EdgeInsets.symmetric(horizontal: SizeTheme.w_md),
                  //   itemCount: testElement.length + 1,
                  //   itemBuilder: (context, index) {
                  //     if (index == testElement.length) {}
                  //     return ListTile(
                  //       shape: Border(),
                  //       leading: SingleChildRoundedCard(
                  //         // padding: EdgeInsets.all(SizeTheme.w_sm),
                  //         child: Image(
                  //           width: 42.w,
                  //           height: 42.w,
                  //           image: AssetImage(
                  //             testElement[index]['type'] == 0
                  //                 ? ImageResource.IMG_TrafficCross
                  //                 : ImageResource.IMG_TrafficYellow,
                  //           ),
                  //         ),
                  //       ),
                  //       title: RichText(
                  //         text: TextSpan(
                  //           text: testElement[index]['type'] == 0
                  //               ? testElement[index]['leading']
                  //               : '황색 점멸등 구간',
                  //           style:
                  //               Theme.of(context).textTheme.bodyMedium!.apply(
                  //                     color: testElement[index]['type'] == 0
                  //                         ? ColorTheme.highlight3
                  //                         : ColorTheme.highlight1,
                  //                   ),
                  //           children: [
                  //             TextSpan(text: ' '),
                  //             TextSpan(
                  //               text: testElement[index]['direction'],
                  //               style: Theme.of(context).textTheme.bodySmall,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       subtitle: Text(
                  //         testElement[index]['name'],
                  //         style: Theme.of(context).textTheme.headlineLarge,
                  //       ),
                  //     );
                  //   },
                  //   separatorBuilder: (context, index) {
                  //     if (index < testElement.length - 1) {
                  //       return Divider();
                  //     }
                  //     return SizedBox();
                  //   },
                  // );
                  // return Column(
                  //   children: snapshot.data!.map((r) {
                  //     if (r.device.name == 'HMSoft') {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(20.0),
                  //         child: SizedBox(
                  //           width: double.infinity,
                  //           height: 60,
                  //           child: ElevatedButton(
                  //             child: Text(
                  //               '역곡역 1번출구 방향 압버튼',
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //             onPressed: (r.advertisementData.connectable)
                  //                 ? () async {
                  //                     await r.device.connect(autoConnect: true);
                  //                     Get.to(() =>
                  //                         PressedBtnView(device: r.device));
                  //                   }
                  //                 : null,
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //     return SizedBox();
                  //   }).toList(),
                  // );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
