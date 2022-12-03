import 'dart:async';

import 'package:get/get.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
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
        Get.snackbar('블루투스 권한을 확인하세요.', '스마트 압버튼 스캔을 위해 앱 내 블루투스 권한을 허가해야합니다.');
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
