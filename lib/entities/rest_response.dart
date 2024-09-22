import 'rest_status_code.dart';

abstract class RestResponse<T> {
  final RestStatusCode restStatusCode;

  RestResponse(this.restStatusCode);

  int get statusCode => restStatusCode.code;
  bool get success => this is RestSuccesResponse;
}

class RestSuccesResponse<T> extends RestResponse<T> {
  final T data;

  RestSuccesResponse({
    required this.data,
    required RestStatusCode restStatusCode,
  }) : super(restStatusCode);
}

class RestException<T> extends RestResponse<T> implements Exception {
  final String? message;

  final dynamic dataResponse;
  final StackTrace? stackTrace;

  RestException({
    required RestStatusCode restStatusCode,
    this.message,
    this.dataResponse,
    this.stackTrace,
  }) : super(restStatusCode);
}
