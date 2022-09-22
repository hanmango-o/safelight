import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/image_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/frame/board_frame.dart';
import 'package:safelight/ui/widget/rounded_button.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';
import 'package:safelight/view_model/controller/auth_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool value = false;
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

  @override
  void initState() {
    super.initState();
    // FlutterBlue.instance.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 1600),
        curve: Curves.fastLinearToSlowEaseIn,
        height: value ? ScreenUtil.defaultSize.height.h : 96.h,
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
              leading: value
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          value = !value;
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
                color: Colors.white,
                height: SizeTheme.h_lg,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: SizeTheme.w_md),
                  itemCount: testElement.length + 1,
                  itemBuilder: (context, index) {
                    if (index == testElement.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeTheme.h_lg * 3,
                        ),
                        child: Center(
                          child: Column(
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
                    }
                    return ListTile(
                      shape: Border(),
                      leading: SingleChildRoundedCard(
                        // padding: EdgeInsets.all(SizeTheme.w_sm),
                        child: Image(
                          width: 42.w,
                          height: 42.w,
                          image: AssetImage(
                            testElement[index]['type'] == 0
                                ? ImageResource.IMG_TrafficCross
                                : ImageResource.IMG_TrafficYellow,
                          ),
                        ),
                      ),
                      title: RichText(
                        text: TextSpan(
                          text: testElement[index]['type'] == 0
                              ? testElement[index]['leading']
                              : '황색 점멸등 구간',
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                                color: testElement[index]['type'] == 0
                                    ? ColorTheme.highlight3
                                    : ColorTheme.highlight1,
                              ),
                          children: [
                            TextSpan(text: ' '),
                            TextSpan(
                              text: testElement[index]['direction'],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                        testElement[index]['name'],
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
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () => null,
            icon: Icon(Icons.flashlight_on_outlined),
          ),
          IconButton(
            onPressed: () => null,
            icon: Icon(Icons.camera_alt_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                vertical: SizeTheme.w_md,
                horizontal: SizeTheme.h_md,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(
                    SizeTheme.r_md,
                  ),
                ),
              ),
              child: Align(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      value = !value;
                    });
                  },
                  icon: Icon(Icons.search),
                  label: Text('횡단보도 압버튼 찾기'),
                ),
              ),
            ),
            BoardFrame(
              title: '제공 서비스',
              // backgroundColor: Colors.amber,
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
                            onTap: () {},
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
                          Divider(),
                          ListTile(
                            onTap: () async {
                              await FirebaseAuth.instance.currentUser!.delete();
                              // await FirebaseAuth.instance.signOut();
                              // await FirebaseAuth.instance.currentUser!.delete();
                            },
                            title: Text('나와 가까운'),
                            subtitle: Text('압버튼 찾기'),
                            leading: SingleChildRoundedCard(
                              child: Icon(
                                Icons.looks,
                                size: 32.sp,
                                color: ColorTheme.highlight3,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () {
                              Get.bottomSheet(WillPopScope(
                                onWillPop: () async {
                                  Get.back(closeOverlays: true);
                                  return false;
                                },
                                child: const Text('dd'),
                              ));
                            },
                            title: Text('가장 가까운'),
                            subtitle: Text(' 압버튼만 스캔 후 누르기'),
                            leading: SingleChildRoundedCard(
                              child: Icon(
                                Icons.panorama_horizontal_select_sharp,
                                size: 32.sp,
                                color: ColorTheme.highlight4,
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
            SizedBox(height: 126.h),

            // BoardFrame(
            //   title: '제공 서비스',
            //   body: GridView.count(
            //     primary: false,
            //     padding: const EdgeInsets.all(20),
            //     crossAxisSpacing: 10,
            //     mainAxisSpacing: 10,
            //     crossAxisCount: 2,
            //     children: <Widget>[
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[100],
            //         child: const Text("He'd have you all unravel at the"),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[200],
            //         child: const Text('Heed not the rabble'),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[300],
            //         child: const Text('Sound of screams but the'),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[400],
            //         child: const Text('Who scream'),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[500],
            //         child: const Text('Revolution is coming...'),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[600],
            //         child: const Text('Revolution, they...'),
            //       ),
            //     ],
            //   ),
            // ),

            // StreamBuilder<List<ScanResult>>(
            //   stream: FlutterBlue.instance.scanResults,
            //   // stream: Stream.periodic(Duration(seconds: 4)).asyncMap((event) => null),
            //   initialData: [],
            //   builder: (c, snapshot) {
            //     if (!snapshot.hasData) {
            //       return Center(child: Text('주변에 SafeLight가 없습니다.'));
            //     }
            //     return Column(
            //       children: snapshot.data!.map((r) {
            //         if (r.device.name == 'HMSoft') {
            //           return Padding(
            //             padding: const EdgeInsets.all(20.0),
            //             child: SizedBox(
            //               width: double.infinity,
            //               height: 60,
            //               child: ElevatedButton(
            //                 child: Text(
            //                   '역곡역 1번출구 방향 압버튼',
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //                 onPressed: (r.advertisementData.connectable)
            //                     ? () async {
            //                         await r.device.connect(autoConnect: true);
            //                         Get.to(
            //                             () => PressedBtnView(device: r.device));
            //                       }
            //                     : null,
            //               ),
            //             ),
            //           );
            //         }
            //         return SizedBox();
            //       }).toList(),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
