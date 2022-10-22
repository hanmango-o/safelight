import 'dart:async';

import 'package:safelight/model/vo/crosswalk_vo.dart';

abstract class ISearchCommandStrategy {
  abstract int rssi;
  abstract Duration duration;

  Future search(StreamController stream);
}
