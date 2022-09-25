import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/image_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/frame/board_frame.dart';
import 'package:safelight/ui/view/blue_bottom_sheet_view.dart';
import 'package:safelight/ui/widget/rounded_button.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BlueController _blueController = Get.find<BlueController>();

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
      bottomSheet: BlueBottomSheetView(),
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
                    // setState(() {
                    //   value = !value;
                    // });

                    print('Start Scan');
                    FlutterBlue.instance.startScan(
                      timeout: Duration(seconds: 1),
                    );
                    setState(() {
                      _blueController.isOpened = !_blueController.isOpened;
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
          ],
        ),
      ),
    );
  }
}
