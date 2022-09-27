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
  Stream<List<CrosswalkVO>>? results;
  bool isOpened = false;

  BlueController() {
    _blueSearchController = _BlueSearchController();
    _blueConnectController = _BlueConnectController();
  }

  StreamController streamController = StreamController<List<CrosswalkVO>>()
    ..add([]);

  Stream<List<CrosswalkVO>>? get test =>
      streamController.stream as Stream<List<CrosswalkVO>>;
  search() {
    try {
      FlutterBlue.instance.startScan(
        timeout: Duration(seconds: 1),
      );
      log('ddd');
    } catch (e) {
      log(e.toString());
    } finally {
      List<CrosswalkVO> results = [];
      FlutterBlue.instance.scanResults.listen((posts) {
        results = posts.map((post) {
          // Map<String, dynamic> map = {
          //   'post': post.device,
          //   'name': post.device.name.isEmpty ? '횡단보도' : post.device.name,
          //   'direction': 'xx방향 yy방면',
          //   'areaType': post.device.name.isEmpty
          //       ? AreaType.INTERSECTION
          //       : AreaType.SINGLE_ROAD,
          // };
          return CrosswalkVO(
            post: post.device,
            name: post.device.name.isEmpty ? '횡단보도' : post.device.name,
            direction: 'xx방향 yy방면',
            areaType: post.device.name.isEmpty
                ? AreaType.INTERSECTION
                : AreaType.SINGLE_ROAD,
          );

          // // if(post.device.name)
          // return CrosswalkVO(
          //   post: post.device,
          //   name: post.device.name.isEmpty ? '횡단보도' : post.device.name,
          //   direction: 'xx방향 yy방면',
          //   connect: (post.advertisementData.connectable)
          //       ? () async {
          //           await post.device.connect(autoConnect: true);
          //           await post.device.discoverServices().then(
          //             (services) async {
          //               await services.first.characteristics.first.write(
          //                 utf8.encode('1'),
          //                 withoutResponse: true,
          //               );
          //             },
          //           );
          //           Get.toNamed('/main/connect');
          //         }
          //       : null,
          //   areaType: post.device.name.isEmpty
          //       ? AreaType.INTERSECTION
          //       : AreaType.SINGLE_ROAD,
          // );
          // FutureBuilder(
          //     future: widget.device.discoverServices().then(
          //       (services) async {
          //         if (services.length > 0) {
          //           await services.first.characteristics.first.write(
          //             utf8.encode('1'),
          //             withoutResponse: true,
          //           );
          //         }
          //       },
          //     ),
          //             onPressed: (r.advertisementData.connectable)
          //                 ? () async {
          //                     await r.device.connect(autoConnect: true);
          //                     Get.to(() =>
          //                         PressedBtnView(device: r.device));
          //                   }
          //                 : null,
        }).toList();

        streamController.add(results);
      });
    }
  }

  Future connect(CrosswalkVO crosswalk) =>
      _blueConnectController.connect(crosswalk);

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
  Future search(
    BlueController controller, {
    Duration timeout = const Duration(seconds: 1),
  }) async {
    try {
      await FlutterBlue.instance.startScan(
        timeout: timeout,
      );
      log('ddd');
    } catch (e) {
      log(e.toString());
    } finally {
      _convert(controller);
    }
  }

  _convert(BlueController controller) {
    List<CrosswalkVO> result = [];
    FlutterBlue.instance.scanResults.listen((event) {
      result = event.map((e) => CrosswalkVO(post: e.device)).toList();
      // log(result.toString());
      controller.results = Stream.value(result);
    });
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
