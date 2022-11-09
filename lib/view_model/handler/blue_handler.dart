import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';
import 'package:safelight/view_model/controller/user_controller.dart';
import 'package:safelight/view_model/interface/search_command_strategy_interface.dart';
import 'package:safelight/view_model/interface/send_command_strategy_interface.dart';

class BlueHandler {
  final StreamController _results =
      StreamController<List<CrosswalkVO>>.broadcast()..add([]);
  ISendCommandStrategy? _sendCMD;
  ISearchCommandStrategy? _searchCMD;

  Stream<List<CrosswalkVO>> get results =>
      _results.stream as Stream<List<CrosswalkVO>>;
  ISendCommandStrategy get sendCMD => _sendCMD!;
  ISearchCommandStrategy get searchCMD => _searchCMD!;

  set sendCMD(ISendCommandStrategy command) => _sendCMD = command;
  set searchCMD(ISearchCommandStrategy command) => _searchCMD = command;

  Future<void> search() async {
    UserController userController = Get.find<UserController>();
    Stream<bool> permisson = userController.auth.checkBluePermission();
// _results.add([]);
    permisson.listen((isGranted) async {
      if (isGranted) {
        try {
          BlueController.isDone.value = true;
          BlueController.status.value = StatusType.IS_SCANNING;
          await _searchCMD!.search(_results);
        } catch (e) {
          throw (Exception(e));
        } finally {
          BlueController.status.value = StatusType.COMPLETE;
        }
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

  Future<void> send() async {
    await _sendCMD!.send();
  }

  Future<void> reset() async {
    _results.add(<CrosswalkVO>[]);
    BlueController.isDone.value = false;
    BlueController.status.value = StatusType.STAND_BY;
  }
}
