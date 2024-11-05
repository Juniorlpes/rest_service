import 'rest_status_code.dart';

/*abstract*/ class RestResponse<T> {
  final RestStatusCode restStatusCode;

  late T data;
  RestException? exception;

  RestResponse(this.restStatusCode);

  int get statusCode => restStatusCode.code;
  bool get success => exception == null;
}

// class RestSuccesResponse<T> extends RestResponse<T> {
//   final T value;

//   RestSuccesResponse({
//     required this.value,
//     required RestStatusCode restStatusCode,
//   }) : super(restStatusCode);
// }

class RestException implements Exception {
  final String? message;

  final dynamic dataResponse;
  final StackTrace? stackTrace;

  RestException({
    this.message,
    this.dataResponse,
    this.stackTrace,
  });
}
