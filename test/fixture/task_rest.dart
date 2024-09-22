import 'package:dio/dio.dart';
import 'package:simple_rest_service/rest_service.dart';

class TaskRest extends RestService {
  TaskRest({
    required Dio dioMock,
    super.getErrorMessage,
  }) : super('http:tasks-api.com', dioClient: dioMock);
}
