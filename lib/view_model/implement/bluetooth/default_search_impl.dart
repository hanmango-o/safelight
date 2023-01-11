import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/view_model/controller/nav_controller.dart';
import 'package:safelight/view_model/handler/nav_handler.dart';
import 'package:safelight/view_model/implement/navigator/get_location_impl.dart';
import 'package:safelight/view_model/interface/search_command_strategy_interface.dart';

class DefaultSearch implements ISearchCommandStrategy {
  NavHandler navHandler = NavHandler();

  static const source = Source.cache;
  @override
  int rssi = -100;

  @override
  Duration duration = const Duration(seconds: 1);

  @override
  Future search(StreamController stream) async {
    List<CrosswalkVO> results = [];

    try {
      await FlutterBluePlus.instance.startScan(
        timeout: duration,
      );
    } catch (e) {
      throw Exception(e);
    } finally {
      List<ScanResult> posts = await FlutterBluePlus.instance.scanResults.first;

      Iterator<ScanResult> post = posts.iterator;

      while (post.moveNext()) {
        if (post.current.device.name.startsWith('AHG001+')) {
          log(post.current.device.name);
          CrosswalkVO crosswalk = CrosswalkVO(post: post.current.device);
          FirebaseFirestore db = FirebaseFirestore.instance;

          final DocumentReference docRef =
              db.collection('safelight_db').doc(post.current.device.name);

          await docRef.get().then(
            (DocumentSnapshot doc) async {
              final data = doc.data();

              if (data != null) {
                Map<String, dynamic> map = data as Map<String, dynamic>;

                crosswalk = CrosswalkVO.fromDB(
                  map,
                  post.current.device,
                  NavController.location,
                );
              }
            },
            onError: (e) => Exception(e),
          );

          log(crosswalk.toString());

          results.add(crosswalk);
        }
        // if (post.current.device.name.startsWith('AHG001+')) {
        //   log(post.current.device.toString());
        //   results.add(
        //     CrosswalkVO(
        //       post: post.current.device,
        //       name: '가톨릭대 앞 횡단보도',
        //       dir: '역곡역 방향',
        //     ),
        //   );
        // }
      }
      stream.add(results);
    }
  }
}
