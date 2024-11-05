import 'package:simple_rest_service/entities/rest_response.dart';

abstract interface class IRestService {
  ///Get a model from webService
  Future<RestResponse<T>> getModel<T>(
    String path,
    //this dynamic json could be a Map<String, dynamic>?
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Get a list model from webService
  Future<RestResponse<List<T>>> getList<T>(
    String path,
    T Function(dynamic) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Post a data and receive a model
  Future<RestResponse<T>> postModel<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Post a data and receive a list model
  Future<RestResponse<List<T>>> postList<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Put a data and receive a model
  Future<RestResponse<T>> putModel<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Put a data and receive a List
  Future<RestResponse<List<T>>> putList<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Delete a model
  Future<RestResponse<void>> deleteModel(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });
}
