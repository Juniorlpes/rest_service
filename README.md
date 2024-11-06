# Simple Rest Service

This package encapsulates and provides you with a Rest Service Interface to simplify your application-side REST API integration.

This package use [Dio](https://pub.dev/packages/dio) package in background and it was based in [restbase package](https://pub.dev/packages/restbase)

## Getting started

Add the package in pubspec.yaml

```
simple_rest_service: ^0.1.0
```

## Usage

You need create a class to be your Rest Api client.
You need create a class for each context you have. It is separated by 'baseUrl'

```
class TaskRestApi extends RestService {
  TaskRestApi() : super('https://your-task-api/api') { 
    
    //This is a interceptor to help you see the events in the debug console
    addInterceptor(PrintLogInterceptor()); 
    
    // This is a interceptor to put access token in the requests. It is optional and very customizable.
    addInterceptor(AuthInterceptor( 
      getToken: () async =>
          (await FirebaseAuth.instance.currentUser?.getIdToken(true)) ?? '',
    ));

  }
}
```

So, after creating the TaskRestApi class, you can call the methods
getModel, getList, postModel, postList ...

```
Future<TaskItemModel> createTask(TaskItemModel item) async {
    final result = await _taskRest.postModel<TaskItemModel>(
      '/task', //The endpoint path
      item.toMap(), //The body
      (json) => TaskItemModel.fromMap(json!), //A function to create and return your object using the json returned by API
    );

    if (result.success) {
      return result.data; //TaskItemModel
    } else {
      //This [GeneralAppFailure] is not a class in the package. It is an example of an Exception known to my application that I am populating with result.exception data. But I could throw the result.exception. It is an Exception.
      throw GeneralAppFailure() 
        ..message = result.exception?.message
        ..statusCode = result.statusCode;
    }
}
```

Please, read the documentation, the source code, send opinions and improvements.

## Explanation

- TODO: Explain and document this package
