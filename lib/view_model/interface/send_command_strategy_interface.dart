import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';

abstract class SendCommandStrategy {
  final List<CrosswalkVO> _crosswalks;

  SendCommandStrategy(this._crosswalks);

  Future<void> send();

  Future<void> connect(List<int> command) async {
    for (int i = 0; i < _crosswalks.length; i++) {
      try {
        await _crosswalks[i].post.connect();
        List<BluetoothService> services =
            await _crosswalks[i].post.discoverServices();
        await services
            .firstWhere(
              (service) =>
                  service.uuid == Guid('0000ffe0-0000-1000-8000-00805f9b34fb'),
            )
            .characteristics
            .firstWhere(
              (characteristic) =>
                  characteristic.uuid ==
                  Guid('0000ffe1-0000-1000-8000-00805f9b34fb'),
            )
            .write(command, withoutResponse: true);
      } catch (e) {
        throw Exception(e);
      } finally {
        await Future.delayed(Duration(seconds: 2));
        await _crosswalks[i].post.disconnect();
      }
    }
  }
}
