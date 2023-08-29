import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mina/data/network/falier.dart';

import '../../presention/resources/string_manager.dart';

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static  String SUCCESS = AppString.success.tr(); // success with data
  static  String NO_CONTENT =
      AppString.success.tr(); // success with no data (no content)
  static  String BAD_REQUEST =
      AppString.badRequestError.tr(); // failure, API rejected request
  static  String UNAUTORISED =
      AppString.unauthorizedError.tr(); // failure, user is not authorised
  static  String FORBIDDEN =
      AppString.forbiddenError.tr(); //  failure, API rejected request
  static  String INTERNAL_SERVER_ERROR =
      AppString.internalServerError.tr(); // failure, crash in server side
  static  String NOT_FOUND =
      AppString.notFoundError.tr(); // failure, crash in server side

  // local status code
  static const String CONNECT_TIMEOUT = AppString.timeoutError;
  static const String CANCEL = AppString.defaultError;
  static const String RECIEVE_TIMEOUT = AppString.timeoutError;
  static const String SEND_TIMEOUT = AppString.timeoutError;
  static const String CACHE_ERROR = AppString.cacheError;
  static const String NO_INTERNET_CONNECTION = AppString.noInternetError;
  static const String DEFAULT = AppString.defaultError;
}

extension DataSourseExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);

      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            ResponseMessage.INTERNAL_SERVER_ERROR); //////to do
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
            ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
            ResponseCode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION,
            ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}

class ErrorHandle implements Exception {
  late Failure failure;

  ErrorHandle.handle(dynamic error) {
    ///in two error///
    if (error is DioException) {
      ///error in api =>Dio//
      failure = _handleError(error);
    } else {
      ///default error///
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}



Failure _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();

    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();

    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();

    case DioExceptionType.badCertificate:
      return DataSource.BAD_REQUEST.getFailure();

    case DioExceptionType.badResponse:
   ///import =>> code & message sent api///
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        return Failure(error.response?.statusCode ?? 0,
            error.response?.statusMessage ?? '');
      } else {
        return DataSource.DEFAULT.getFailure();
      }

    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();

    case DioExceptionType.connectionError:
      return DataSource.CACHE_ERROR.getFailure();

    case DioExceptionType.unknown:
      return DataSource.DEFAULT.getFailure();
  }
}
class ApiInternal{

  static const int SUCCESS=0;
  static const int FAILURE=1;

}