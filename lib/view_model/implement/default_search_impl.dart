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
        withServices: [Guid('0000ffe0-0000-1000-8000-00805f9b34fb')],
      );
    } catch (e) {
      throw Exception(e);
    } finally {
      FlutterBluePlus.instance.scanResults.listen(
        (posts) {
          Iterator<ScanResult> post = posts.iterator;
          while (post.moveNext()) {
            results.add(
              CrosswalkVO(
                post: post.current.device,
                name: post.current.device.name.isNotEmpty
                    ? post.current.device.name == 'HMSoft'
                        ? '가톨릭대 앞 횡단보도'
                        : '횡단보도'
                    : '횡단보도',
                direction: '역곡역 방향',
                areaType: post.current.device.name.isEmpty
                    ? AreaType.INTERSECTION
                    : AreaType.SINGLE_ROAD,
              ),
            );
          }
          stream.add(results);
        },
      );
    }
  }
}
