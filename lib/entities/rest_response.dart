import 'package:rest_service/entities/rest_failure.dart';

class RestResponse<T> {
  late T data;
  RestFailure? failure;

  int? statusCode;

  bool get success => failure == null;
}
