import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpsRepository {
  Future<Response> fetchGet(String url) async {
    try {
      final uri = Uri.parse(url);
      Response response = await http.get(uri);
      return response;
    } catch (e) {
      throw (Exception(e));
    }
  }

  Future fetchPost() async {}

  // var url = Uri.https(authority)
}
