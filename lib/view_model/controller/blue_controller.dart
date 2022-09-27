import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/asset/resource/service_resource.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/ui/view/connected_view.dart';

class BlueController extends GetxController {
  late _BlueSearchController _blueSearchController;
  late _BlueConnectController _blueConnectController;
  bool isOpened = false;
  Rx<StatusType> status = StatusType.STAND_BY.obs;

  BlueController() {
    _blueSearchController = _BlueSearchController();
    _blueConnectController = _BlueConnectController();
  }

  StreamController resultStream = StreamController<List<CrosswalkVO>>()
    ..add([]);

  Stream<List<CrosswalkVO>>? get results =>
      resultStream.stream as Stream<List<CrosswalkVO>>;

  search() async {
    status.value = StatusType.IS_SCANNING;
    await _blueSearchController.search(resultStream);
    status.value = StatusType.COMPLETE;
  }

  reset() {
    resultStream.add(<CrosswalkVO>[]);
    status.value = StatusType.STAND_BY;
  }

  Future connect(CrosswalkVO crosswalk) =>
      _blueConnectController.connect(crosswalk).then((value) => reset());

  Future services(ServiceType type) async {
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
