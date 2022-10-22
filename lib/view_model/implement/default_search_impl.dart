import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/view_model/interface/search_command_strategy_interface.dart';

class DefaultSearch implements ISearchCommandStrategy {
  @override
  int rssi = -100;

  @override
  Duration duration = Duration(seconds: 1);

  @override
  Future search(StreamController stream) async {
    print('default search start!');
    List<CrosswalkVO> results = [];

    try {
      await FlutterBluePlus.instance.startScan(
        timeout: duration,
      );
    } catch (e) {
      throw Exception(e);
    } finally {
      FlutterBluePlus.instance.scanResults.listen(
        (posts) {
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
          stream.add(results);
        },
      );
    }
  }
}
