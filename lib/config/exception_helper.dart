import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/base_response.dart';
import '../utils/constant.dart';
import '../utils/customs/custom_toast.dart';

class ExceptionHelper<T> {
  final DioException e;
  ExceptionHelper(this.e);

  Future<BaseResponse<T>> catchException({bool activateToast = true}) async {
    String message = '';
    int statusCode = 0;

    await Sentry.captureException(e, stackTrace: e.stackTrace);

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = kBplsConnectionTimeout;
        statusCode = 500;
        break;
      case DioExceptionType.sendTimeout:
        message = kBplsConnectionTimeout;
        statusCode = 500;
        break;
      case DioExceptionType.receiveTimeout:
        message = kBplsConnectionTimeout;
        statusCode = 500;
        break;
      case DioExceptionType.badCertificate:
        message = kBplsConnectionTimeout;
        statusCode = 500;
        break;
      case DioExceptionType.connectionError:
        message = kBplsNoInternetConnection;
        statusCode = 500;
        break;
      case DioExceptionType.badResponse:
        if (e.response == null) {
          return BaseResponse(
            message: kBplsErrorCantReachServer,
            statusCode: 0,
          );
        }
        final eResponse = e.response!;
        final statusCode = e.response!.statusCode;

        if (statusCode == 401) {
          if (eResponse is String) {
            message = eResponse as String;
          } else {
            message = '401 Error';
          }
        }
        if (eResponse.data['message'] != null) {
          message = eResponse.data['message'] ?? kBplsErrorException;
        } else {
          message = eResponse.toString();
        }
        return BaseResponse(
          message: message,
          statusCode: statusCode,
          data: eResponse.data,
        );
      case DioExceptionType.cancel:
        message = kBplsErrorException;
        statusCode = 500;

        break;
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          message = kBplsNoInternetConnection;
        } else {
          message = e.message ?? '';
        }
        statusCode = 500;

        break;
    }

    activateToast ? CustomToast.showToastError(message) : {};
    // statusCode >= 500 ? CustomToast.showToastError(message) : {};
    return BaseResponse(
      message: message,
      statusCode: statusCode,
      data: e.response?.data['errors'],
    );
  }
}
