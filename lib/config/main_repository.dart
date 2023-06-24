import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../services/di_service.dart';

class MainRepository {
  MainRepository() {
    _init();
  }

  _init() async {
    await setConfig();

    // ignore: use_build_context_synchronously
    GetIt.I<GoRouter>()
        .routerDelegate
        .navigatorKey
        .currentState!
        .context
        .goNamed('home');
  }

  Future<void> setConfig() async {
    Dio dio = await _setupDio();
    DIService.initializeConfig(dio);
  }

  Future<Dio> _setupDio() async {
    BaseOptions options = BaseOptions(
        baseUrl: 'http://api.openweathermap.org/',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        sendTimeout: const Duration(seconds: 8),
        headers: {
          'accept': 'application/json',
          'X-Localization': 'id',
        });

    Dio dio = Dio(options);

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      error: true,
      request: true,
      requestBody: true,
      // requestHeader: true,
      // responseHeader: true,
    ));

    return dio;
  }
}
