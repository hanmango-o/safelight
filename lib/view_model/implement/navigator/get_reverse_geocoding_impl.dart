import 'dart:convert';
import 'dart:developer';

import 'package:safelight/asset/resource/auth_resource.dart';
import 'package:safelight/view_model/interface/fetch_strategy_interface.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

// 위도, 경도 > 주소
class GetReverseGeocoding implements IFetchStrategy {
  late double lat;
  late double lon;

  GetReverseGeocoding(List<double> location) {
    lat = location[0];
    lon = location[1];
  }

  @override
  Future fetch() async {
    String uri =
        'https://apis.openapi.sk.com/tmap/geo/reversegeocoding?version=1&lat=$lat&lon=$lon&appKey=${API.key}';

    try {
      final url = Uri.parse(uri);
      Response response = await http.get(url);
      var json = jsonDecode(response.body);
      return json['addressInfo']['fullAddress'];
    } catch (e) {
      throw (Exception(e));
    }
  }
}
