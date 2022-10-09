import 'dart:async';

import 'package:safelight/model/vo/crosswalk_vo.dart';

abstract class SearchCommandStrategy {
  abstract int _rssi;
  abstract Duration _duration;

  Future search(StreamController stream);
}
