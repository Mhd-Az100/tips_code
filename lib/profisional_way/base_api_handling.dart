import 'package:flutter/material.dart';
import 'package:tips_code/dependency_injection/injection_container.dart';
import 'package:tips_code/profisional_way/base_api_exceptions.dart';

class BaseHandleApi {
  //

  handleError(exception) {
    if (exception is FetchDataException) {
      showErrorDialog(exception);
    }
    //
    else if (exception is InvalidInputException) {
      showErrorDialog(exception);
    }
    //
    else if (exception is UnauthorisedException) {
      showErrorDialog(exception);
    }
    //
    else if (exception is ApiNotRespondingException) {
      showErrorDialog(exception);
    }
  }

  //

  Widget? showErrorDialog(AppException exception) {
    showDialog<Widget>(
      barrierDismissible: false,
      //
      //! get context from navigator key with Dependency injection
      context: getIt<GlobalKey<NavigatorState>>().currentContext!,
      //
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: const Text('error'),
            content: Text(
              exception.message ?? 'Something Wrong',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  (exception is UnauthorisedException)
                      ? {
                          //??? Go Sign in Page
                        }
                      : Navigator.pop(context);
                },
                child: Text(
                  (exception is UnauthorisedException) ? 'signin' : 'ok',
                ),
              ),
            ],
          ),
        );
      },
    );
    return null;
  }
}
