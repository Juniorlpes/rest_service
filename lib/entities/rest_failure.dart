import 'request_errors.dart';

///This class has commoms API services errors to avoid repetition on modules failures
class RestFailure implements Exception {
  String? message;
  RequestErrors? requestErrors;

  RestFailure({this.message, this.requestErrors});

  bool get hasRequestErrors => requestErrors != null;
  bool get isConnectionError => requestErrors == RequestErrors.connectionError;
  bool get isServerError => requestErrors == RequestErrors.serverError;
}
