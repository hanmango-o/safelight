import 'dart:convert';

import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/view_model/interface/send_command_strategy_interface.dart';

class TestSignal extends ISendCommandStrategy {
  static final List<int> _command = utf8.encode('1');

  TestSignal({required List<CrosswalkVO> crosswalks}) : super(crosswalks);

  @override
  Future<void> send() async {
    await super.connect(_command);
  }
}
