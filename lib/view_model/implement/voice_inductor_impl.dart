import 'dart:developer';

import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/view_model/interface/send_command_strategy_interface.dart';

class VoiceInductor extends ISendCommandStrategy {
  static const List<int> _command = [0x31, 0x00, 0x01];

  VoiceInductor({required List<CrosswalkVO> crosswalks}) : super(crosswalks);

  @override
  Future<void> send() async {
    await super.connect(_command);
  }
}
