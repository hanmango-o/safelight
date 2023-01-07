import 'package:get/get.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/view_model/handler/blue_handler.dart';

class BlueController extends GetxController {
  static Rx<StatusType> status = StatusType.STAND_BY.obs;
  static Rx<bool> isDone = false.obs;

  final BlueHandler _blueHandler = BlueHandler();

  BlueHandler get blueHandler => _blueHandler;
}
