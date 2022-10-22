// ignore_for_file: avoid_returning_null_for_void

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safelight/asset/resource/service_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/frame/board_frame.dart';
import 'package:safelight/ui/view/blue_bottom_sheet_view.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';
import 'package:safelight/view_model/handler/blue_handler.dart';
import 'package:safelight/view_model/implement/default_search_impl.dart';
import 'package:safelight/view_model/interface/service_strategy_interface.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BlueController _blueController = Get.find<BlueController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const BlueBottomSheetView(),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => null,
            icon: const Icon(Icons.flashlight_on_outlined),
          ),
          IconButton(
            onPressed: () => null,
            icon: const Icon(Icons.camera_alt_outlined),
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
              /*
              ScanResult{device: BluetoothDevice{id: 5FCB86D0-3318-B901-42F0-1A7E7EAE9BB6, name: HMSoft, type: BluetoothDeviceType.le, isDiscoveringServices: false, _services: [], advertisementData: AdvertisementData{localName: HMSoft, txPowerLevel: null, connectable: true, manufacturerData: {19784: [176, 16, 160, 116, 247, 29]}, serviceData: {B000: [0, 0, 0, 0]}, serviceUuids: [FFE3]}, rssi: -37}
              */
              child: Align(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    _blueController.blueHandler.searchCMD = DefaultSearch();
                    await _blueController.blueHandler.search();
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('횡단보도 압버튼 찾기'),
                ),
              ),
            ),
            BoardFrame(
              title: '제공 서비스',
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
                              await _blueController.doService();
                            },
                            title: const Text('바라보는 방향 기준'),
                            subtitle: const Text('압버튼 찾기'),
                            leading: SingleChildRoundedCard(
                              child: Icon(
                                Icons.play_circle_outline_rounded,
                                size: 32.sp,
                                color: ColorTheme.highlight1,
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            onTap: () async {
                              await _blueController.doService();
                            },
                            title: const Text('압버튼 스캔 후'),
                            subtitle: const Text('모두 누르기'),
                            leading: SingleChildRoundedCard(
                              child: Icon(
                                Icons.radio_button_checked_rounded,
                                size: 32.sp,
                                color: ColorTheme.highlight2,
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            onTap: () async {
                              await _blueController.doService();
                            },
                            title: const Text('나와 가까운'),
                            subtitle: const Text('압버튼 찾기'),
                            leading: SingleChildRoundedCard(
                              child: Icon(
                                Icons.looks,
                                size: 32.sp,
                                color: ColorTheme.highlight3,
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            onTap: () async {
                              await _blueController.doService();
                            },
                            title: const Text('가장 가까운'),
                            subtitle: const Text(' 압버튼만 스캔 후 누르기'),
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
