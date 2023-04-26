import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tips_code/profisional_way/base_api_exceptions.dart';
import 'package:tips_code/profisional_way/base_response_model.dart';
import 'package:tips_code/profisional_way/network_connection_checker.dart';

enum ApiMethod { post, get, put, delete, patch }

class ApiProvider {
  final http.Client client;
  final NetworkInfoImpl networkInfo;
  ApiProvider(
    this.client,
    this.networkInfo,
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
      'Authorization': 'Bearer "Token"}',
      //?? Token from Shared Preferences or any local storage package...
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
      throw ApiNotRespondingException('Check internet connection');
    }
    //
    on TimeoutException {
      throw ApiNotRespondingException(
          'Api not responded in time , Check connection quality');
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
        throw InvalidInputException('Inconsistency with the entered data');
      case 401:
      case 403:
        throw UnauthorisedException('Session expired , please signin again');
      case 500:
        throw FetchDataException('Error During Communication');
      default:
        throw FetchDataException('Error During Communication');
    }
  }
}
