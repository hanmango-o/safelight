import 'package:get/get.dart';
import 'package:safelight/view_model/interface/service_strategy_interface.dart';

class ServiceController extends GetxController {
  IServiceStrategy? _strategy;

  IServiceStrategy get strategy => _strategy!;

  set strategy(IServiceStrategy service) {
    _strategy = service;
  }
}
