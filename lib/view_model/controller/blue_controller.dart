import 'package:get/get.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/view_model/handler/blue_handler.dart';
import 'package:safelight/view_model/strategy/service_strategy.dart';

class BlueController extends GetxController {
  static Rx<StatusType> status = StatusType.STAND_BY.obs;
  static Rx<bool> isDone = false.obs;

  BlueHandler _blueHandler = BlueHandler();
  ServiceStrategy? _service;

  BlueHandler get blueHandler => _blueHandler;
  ServiceStrategy get service => _service!;

  set service(ServiceStrategy service) {
    _service = service;
  }

  Future<void> doService() async {
    await _service!.doService();
  }
}
