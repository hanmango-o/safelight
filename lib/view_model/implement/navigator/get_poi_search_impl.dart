import 'dart:convert';
import 'dart:developer';

import 'package:safelight/asset/resource/auth_resource.dart';
import 'package:safelight/model/vo/location_vo.dart';
import 'package:safelight/view_model/interface/fetch_strategy_interface.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

// 장소 통합 검색 > 검색어를 통한 장소 도출에 사용
class GetPOISearchImpl implements IFetchStrategy {
  late String input;

  GetPOISearchImpl({required this.input});

  @override
  Future fetch() async {
    try {
      String location = Uri.encodeFull(input);

      String uri =
          'https://apis.openapi.sk.com/tmap/pois?version=1&page=1&count=15&searchKeyword=$location&appKey=${API.key}';
      final url = Uri.parse(uri);
      Response response = await http.get(url);
      var json = jsonDecode(response.body);
      // log(json.toString());
      // log(json.toString());
      // log(json['searchPoiInfo'].toString());
      // log(json['searchPoiInfo']['pois']['poi'].toString());
      List<LocationVO> locations = [];
      List a = json['searchPoiInfo']['pois']['poi'];
      for (var poi in a) {
        locations.add(
          LocationVO(
            name: poi['name'],
            lat: double.parse(poi['noorLat']),
            lon: double.parse(poi['noorLon']),
            address: poi['newAddressList']['newAddress'][0]['fullAddressRoad'],
          ),
        );
      }
      return locations;
    } catch (e) {
      throw (Exception(e));
    }
  }
}
/*
{poi: [{id: 1582763, pkey: 158276300, navSeq: 0, collectionType: poi, name: 당산역[9호선], telNo: 02-2656-0913, frontLat: 37.53423434, frontLon: 126.90130675, noorLat: 37.53378996, noorLon: 126.90205669, upperAddrName: 서울, middleAddrName: 영등포구, lowerAddrName: 당산동6가, detailAddrName: , mlClass: 1, firstNo: 227, secondNo: 1, roadName: 양평로, firstBuildNo: 40, secondBuildNo: , radius: 0.0, bizName: , upperBizName: 교통편의, middleBizName: 교통시설, lowerBizName: 지하철역, detailBizName: 9호선, rpFlag: 5, parkFlag: 0, detailInfoFlag: 1, desc: 당산역은 한강에 인접해있는 지상 고가역으로서 당산철교와 고수부지가 있으며 양평동과 당산동 사이에 자리하고 있다. 일산 신도시 및 공항동, 인천방향으로 가는 연계수송인원과 주변마을 버스 이용자가 다수이며 인근에는 각종 은행, 보험회사 및 중소기업들이 많이 있다., dataKind: 1, zipCode: 07214, newAddressList: {newAddress: [{centerLat: 37.53378996, centerLon: 126.90205669, frontLat: 37.53423434, frontLon: 126.90130675, roadName: 양평로, bldNo1: 40, bldNo2: , roadId: 00626, fullAddressRoad: 서울 영등포구 양평로 지하 40}]}, evChargers: {evCharger: []}},
*/