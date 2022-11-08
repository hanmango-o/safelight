import 'dart:developer';

import 'package:get/get.dart';
import 'package:safelight/view_model/handler/nav_handler.dart';
import 'package:safelight/view_model/implement/navigator/get_poi_search_impl.dart';
import 'package:safelight/view_model/interface/fetch_strategy_interface.dart';

import '../implement/navigator/get_location_impl.dart';
import '../implement/navigator/get_reverse_geocoding_impl.dart';

class NavController extends GetxController {
  // static Rx<String> location = ''.obs;
  NavHandler navHandler = NavHandler();

  Future getLocation() async {
    navHandler.strategy = GetLocationImpl();
    List<double> location = await navHandler.fetch();
    navHandler.strategy = GetReverseGeocoding(location);
    return await navHandler.fetch();
  }

  Future getPOISearch(String input) async {
    navHandler.strategy = GetPOISearchImpl(input: input);
    return await navHandler.fetch();
  }
}
