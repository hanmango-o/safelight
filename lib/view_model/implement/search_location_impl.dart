// import 'dart:convert';
// import 'dart:developer';

// import 'package:http/http.dart';
// import 'package:safelight/model/repository/https_repository.dart';
// import 'package:safelight/view_model/interface/http_strategy.dart';

// class SearchLocationImpl {
//   HttpsRepository repository = HttpsRepository();

//   Future fetchGet(String input) async {
//     var target = Uri.encodeFull(input);
//     //
//     print(target);
//     String url =
//         'https://apis.openapi.sk.com/tmap/pois?version=1&searchKeyword=$target&appKey=l7xx1c52cfb4727b430fa699f5721183d086';

//     Response response = await repository.fetchGet(url);
//     log(response.body.toString());
//   }
// }
