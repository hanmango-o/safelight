import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/asset/resource/service_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/ui/view/connected_view.dart';
import 'package:safelight/view_model/controller/user_controller.dart';
import 'package:safelight/view_model/implement/bluetooth_permission_authorized_imp.dart';

class BlueController extends GetxController {
  late _BlueSearchController _blueSearchController;
  late _BlueConnectController _blueConnectController;
  Rx<bool> isOpened = false.obs;
  Rx<StatusType> status = StatusType.STAND_BY.obs;

  BlueController() {
    _blueSearchController = _BlueSearchController();
    _blueConnectController = _BlueConnectController();
  }

  StreamController resultStream =
      StreamController<List<CrosswalkVO>>.broadcast()..add([]);

  Stream<List<CrosswalkVO>>? get results =>
      resultStream.stream as Stream<List<CrosswalkVO>>;

  Future<void> search() async {
    UserController userController = Get.find<UserController>();
    Stream<bool> isGranted = userController.auth.checkBluePermission();

    isGranted.listen((isGranted) async {
      if (isGranted) {
        isOpened.value = true;
        status.value = StatusType.IS_SCANNING;
        await _blueSearchController.search(resultStream);
        status.value = StatusType.COMPLETE;
      } else {
        Get.defaultDialog(
          title: '앱의 블루투스 접근 권한이\n허용되지 않았습니다.',
          titleStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: ColorTheme.onSecondary,
          ),
          middleTextStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: ColorTheme.onSecondary,
          ),
          middleText:
              'BLE 통신을 위해 앱 내 블루투스 기능의 허가가 필요합니다. 아래의 버튼을 눌러 블루투스 기능을 켜주세요.',
          onConfirm: () async {
            await userController.auth.blueAuthorized();
            Get.back();
          },
          onCancel: () => Get.back(),
          textCancel: '취소',
          textConfirm: '확인',
          confirmTextColor: Colors.blue,
          cancelTextColor: Colors.red,
        );
      }
    });
  }

  Future<void> reset() async {
    resultStream.add(<CrosswalkVO>[]);
    isOpened.value = false;
    status.value = StatusType.STAND_BY;
  }

  Future<void> connect(CrosswalkVO crosswalk) =>
      _blueConnectController.connect(crosswalk).then((value) => reset());

  Future<void> services(ServiceType type) async {
    switch (type) {
      case ServiceType.SEARCH_BY_DIRECTION_OF_VIEW:
        log('바라보는 방향 기준 압버튼 찾기');
        break;
      case ServiceType.CONNECT_ALL_IMMEDIATELY_AFTER_SEARCH:
        log('압버튼 스캔 후 모두 누르기');
        break;
      case ServiceType.SEARCH_FOR_NEARBY:
        log('나와 가까운 압버튼 찾기');
        break;
      case ServiceType.CONNECT_IMMEDIATELY_AFTER_SEARCH_FOR_NEARBY:
        log('가장 가까운 압버튼만 스캔 후 누르기');
        break;
    }
  }
}

class _BlueSearchController {
  Future search(StreamController streamController) async {
    try {
      await FlutterBlue.instance.startScan(
        timeout: Duration(seconds: 1),
      );
    } catch (e) {
      log(e.toString());
    } finally {
      List<CrosswalkVO> results = [];
      FlutterBlue.instance.scanResults.listen((posts) {
        results = posts.map((post) {
          return CrosswalkVO(
            post: post.device,
            name: post.device.name.isEmpty ? '횡단보도' : post.device.name,
            direction: 'xx방향 yy방면',
            areaType: post.device.name.isEmpty
                ? AreaType.INTERSECTION
                : AreaType.SINGLE_ROAD,
          );
        }).toList();

        streamController.add(results);
      });
    }
  }
}

class _BlueConnectController {
  Future connect(CrosswalkVO crosswalk) async {
    await crosswalk.post.connect(autoConnect: true);
    await crosswalk.post.discoverServices().then(
      (services) async {
        await services.first.characteristics.first.write(
          utf8.encode('1'),
          withoutResponse: true,
        );
      },
    );
    Get.to(() => ConnectedView(crosswalk: crosswalk));
  }
}
