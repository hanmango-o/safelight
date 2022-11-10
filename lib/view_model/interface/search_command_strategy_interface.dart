import 'dart:async';

abstract class ISearchCommandStrategy {
  abstract int rssi;
  abstract Duration duration;

  Future search(StreamController stream);
}
