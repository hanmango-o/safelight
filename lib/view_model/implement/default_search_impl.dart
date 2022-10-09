import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/view_model/strategy/search_command_strategy.dart';

class DefaultSearch extends SearchCommandStrategy {
  @override
  int _rssi = -100;

  @override
  Duration _duration = Duration(seconds: 1);

  @override
  Future search(StreamController stream) async {
    print('default search start!');
    List<CrosswalkVO> results = [];

    try {
      await FlutterBluePlus.instance.startScan(
        timeout: _duration,
      );
    } catch (e) {
      Get.snackbar('에러가 발생했습니다.', e.toString());
    } finally {
      FlutterBluePlus.instance.scanResults.listen(
        (posts) {
          // log(posts.toString());
          results = posts.map((post) {
            // log(post.toString());
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
