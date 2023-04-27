part of data_source;

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(LatLng position);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  @override
  Future<WeatherModel> getCurrentWeather(LatLng position) async {
    try {
      final url = Uri.parse(
        WeatherAPI.postionURL(position.latitude, position.longitude),
      );
      var response = await http.get(url);
      Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherModel.fromJson(json);
    } catch (e) {
      throw ServerException();
    }
  }
}

abstract class TmapDataSource {
  Future<TmapModel> getTmap(LatLng position);
}

class TmapDataSourceImpl implements TmapDataSource {
  @override
  Future<TmapModel> getTmap(LatLng position) async {
    try {
      final url = Uri.parse(
        TmapAPI.postionURL(position.latitude, position.longitude),
      );
      var response = await http
          .post(url, body: {'key': 'MgEywRxoHF2lbtY92eQcB2F66A70xKyJ22Au6dzE'});
      Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;
      return TmapModel.fromJson(json);
    } catch (e) {
      throw ServerException();
    }
  }
}
