import 'rest_status_code.dart';

///This is the class that will be returned when a call is made to the REST API.
///It is typed with the data that will be returned. In case of an error, it will return a [RestException] in the [exception] field.
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

///This class implements an Exception and gets all the information from the DioException if there is a failure at the endpoint.
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
