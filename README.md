# Rest Service

This package encapsulates and provides you with a Rest Service Interface to simplify your application-side REST API integration.

This package use [Dio](https://pub.dev/packages/dio) package in background and it was based in [restbase package](https://pub.dev/packages/restbase)

## Getting started

Add the package in pubspec.yaml

```
simple_rest_service: ^0.0.8
```

## Usage

You need create a class to be your Rest Api client.
You need create a class for each context you have. It is separated by 'baseUrl'

```
class TaskRestApi extends RestService {
  TaskRestApi() : super('https://your-task-api/api') {
    addInterceptor(PrintLogInterceptor());
    addInterceptor(AuthInterceptor(
      getToken: () async =>
          (await FirebaseAuth.instance.currentUser?.getIdToken(true)) ?? '',
    ));
  }
}
```

The package has the PrintLogInterceptor to help you see the events in the debug console and the AuthInterceptor to put you access token in the requests.
These are optional and very customizable.

So, after creating the TaskRestApi class, you can call the methods
getModel, getList, postModel, postList ...

```
Future<TaskItemModel> createTask(TaskItemModel item) async {
    final result = await _todoRest.postModel(
      '/task',
      item.toMap(),
      (json) => TodoItemModel.fromMap(json!),
    );

    if (result.success) {
      return result.data;
    } else {
      throw GeneralAppFailure()
        ..message = result.exception?.message
        ..statusCode = result.statusCode;
    }
}
```

Please, read the documentation, the source code, send opinions and improvements.