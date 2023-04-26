// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tips_code/profisional_way/base_api_provider.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton(() => ApiProvider(getIt(), getIt()));
  getIt.registerLazySingleton(http.Client.new);
  getIt.registerLazySingleton(() => InternetConnectionChecker());

  final navigatorKey = GlobalKey<NavigatorState>();
  getIt.registerLazySingleton<GlobalKey<NavigatorState>>(() => navigatorKey);
}
