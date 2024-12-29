import 'package:dio/dio.dart';
import 'package:simple_rest_service/rest_service.dart';

class TaskRest extends RestService {
  TaskRest({
    required Dio dioMock,
    String? baseUrl,
    super.getErrorMessage,
  }) : super(baseUrl ?? 'http:tasks-api.com', dioClient: dioMock);
}
