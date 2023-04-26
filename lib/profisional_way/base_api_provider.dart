import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tips_code/profisional_way/base_api_exceptions.dart';
import 'package:tips_code/profisional_way/base_response_model.dart';

enum ApiMethod { post, get, put, delete, patch }

class ApiProvider {
  final http.Client client;
  ApiProvider(
    this.client,
  );
  //
  static const int TIME_OUT_DURATION = 20;
  static const String BaseUrl = "base url example";

  Future<JsonResponse?> goApi({
    required String url,
    required ApiMethod method,
    dynamic body,
    Map<String, String>? additionalHeader,
  }) async {
    //
    final baseHeader = {
      'Accept': 'application/json',
      'lang': "en",
      'Authorization': 'Bearer ${getIt<Session>().getToken()}', //?? get Token
    };
    //
    http.Response? response;
    //
    baseHeader.addAll(additionalHeader ?? {});
    try {
      //?? check internet connection
      if (!(await networkInfo.isConnected)) {
        throw ApiNotRespondingException('error_not_responsed');
      }
      switch (method) {
        //
        case ApiMethod.get:
          response = await client
              .get(
                Uri.parse(
                  BaseUrl + url,
                ),
                headers: baseHeader,
              )
              .timeout(const Duration(seconds: TIME_OUT_DURATION));

          break;
        //
        case ApiMethod.post:
          response = await client
              .post(
                Uri.parse(
                  BaseUrl + url,
                ),
                headers: baseHeader,
                body: body,
              )
              .timeout(const Duration(seconds: TIME_OUT_DURATION));

          break;

        case ApiMethod.put:
          response = await client
              .put(
                Uri.parse(
                  BaseUrl + url,
                ),
                headers: baseHeader,
                body: body,
              )
              .timeout(const Duration(seconds: TIME_OUT_DURATION));

          break;

        case ApiMethod.delete:
          response = await client
              .delete(
                Uri.parse(
                  BaseUrl + url,
                ),
                headers: baseHeader,
              )
              .timeout(const Duration(seconds: TIME_OUT_DURATION));
          break;

        default:
      }
    }
    //
    on SocketException {
      throw ApiNotRespondingException('error_not_responsed');
    }
    //
    on TimeoutException {
      throw ApiNotRespondingException('error_not_responsed');
    }
    //
    catch (e) {
      throw FetchDataException('error_server');
    }

    // check status of response

    switch (response!.statusCode) {
      case 200:
      case 201:
      case 202:
      case 203:
        final res = JsonResponse.fromJson(jsonDecode(response.body));

        return res;
      case 400:
      case 422:
        throw InvalidInputException('error_input');
      case 401:
      case 403:
        throw UnauthorisedException('error_unauth');
      case 500:
        throw FetchDataException('error_server');
      default:
        throw FetchDataException('error_server');
    }
  }
}
