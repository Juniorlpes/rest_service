import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_rest_service/rest_service.dart';

import 'fixture/task_model.dart';
import 'fixture/task_rest.dart';

class DioMock extends Mock implements Dio {}

void main() {
  final dioMock = DioMock();
  final taskRest = TaskRest(
    dioMock: dioMock,
    getErrorMessage: (data) => data['error'],
  );

  test('Get task successfully', () async {
    //Arrange
    when(() => dioMock.get(any())).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        statusCode: 200,
        data: {
          'id': '123',
          'task': 'test',
        },
      ),
    );

    //Act
    final result =
        await taskRest.getModel<Task>('/tasks', (json) => Task.fromMap(json!));

    //Assert
    expect(result.success, true);
    expect(result.statusCode, 200);
    expect((result as RestSuccesResponse).data.id, '123');
  });

  test('Receive Exception when search task', () async {
    //Arrange
    when(() => dioMock.get(any())).thenThrow(DioException(
      requestOptions: RequestOptions(),
      response: Response(
        requestOptions: RequestOptions(),
        data: {'error': 'Task Not Found'},
        statusCode: 404,
      ),
      message: 'Not found',
    ));

    //Act
    final result = await taskRest.getModel<Task>(
        'tasks/123', (json) => Task.fromMap(json!));

    //Assert
    expect(result.success, false);
    expect(result.statusCode, 404);
    expect((result as RestException).message, 'Task Not Found');
  });
}
