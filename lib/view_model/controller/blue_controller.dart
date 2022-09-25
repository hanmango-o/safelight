import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:safelight/view_model/controller/blue_connect_controller.dart';
import 'package:safelight/view_model/controller/blue_search_controller.dart';

class BlueController extends GetxController {
  late BlueSearchController _blueSearchController;
  late BlueConnectController _blueConnectController;

  BlueController() {
    _blueSearchController = BlueSearchController();
    _blueConnectController = BlueConnectController();
  }

  BlueSearchController get search => _blueSearchController;
  BlueConnectController get connect => _blueConnectController;

  bool isOpened = false;
}
