part of core;

abstract class APIS {}

class WeatherAPI implements APIS {
  static String postionURL(double lat, double lon) =>
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=e5a7b17b215d3503ab23e2066fba37dc';
}

class CrosswalkAPI implements APIS {
  static List<Map<String, dynamic>> map = [];
}

class TmapAPI implements APIS {
  static String postionURL(double latitude, double longitude) =>
      'https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&startX=126.92365493654832&startY=37.556770374096615&endX=126.92432158129688&endY=37.55279861528311&startName="홍대입구"&endName="홍대앞"&type=FeatureCollection';
}
