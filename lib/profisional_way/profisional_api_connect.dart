import 'dart:async';

import 'package:tips_code/dependency_injection/injection_container.dart';
import 'package:tips_code/profisional_way/base_api_handling.dart';
import 'package:tips_code/profisional_way/base_api_provider.dart';

class ProfitionalAPiConnection with BaseHandleApi {
  //
  final client = getIt<ApiProvider>();
  //
  Future<dynamic> getDataFromApi() async {
    await client
        .goApi(
          method: ApiMethod.get,
          url: "example",
          // additionalHeader: {} //?? you can add additional parameters
        )
        .catchError(handleError); //?? catch all errors
  }
}
