import 'package:simple_rest_service/entities/rest_failure.dart';

import 'rest_status_code.dart';

class RestResponse<T> {
  late T data;
  late RestStatusCode restStatusCode;
  RestFailure? failure;

  int get statusCode => restStatusCode.code;

  bool get success => failure == null;
}
