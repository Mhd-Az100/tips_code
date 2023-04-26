import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class TraditionalAPiConnection {
  //
  final client = http.Client();
  //
  Future<dynamic> getDataFromApi() async {
    try {
      //
      var response = await client.get(Uri.parse("https://example.com/api/"));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "Error";
      }
    }
    //
    on SocketException {
      log("check internet connection");
    }
    //
    on TimeoutException {
      log("not response try again");
    }
    //
    catch (e) {
      log(e.toString());
    }
  }
}
