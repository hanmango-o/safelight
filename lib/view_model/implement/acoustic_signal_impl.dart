import 'dart:convert';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/view_model/strategy/send_command_strategy.dart';

class AcousticSignal extends SendCommandStrategy {
  @override
  List<int> _command = [0x31, 0x00, 0x02];

  AcousticSignal({required List<CrosswalkVO> crosswalks}) : super(crosswalks);

  @override
  Future<void> send() async {
    await super.connect(_command);
  }
}
