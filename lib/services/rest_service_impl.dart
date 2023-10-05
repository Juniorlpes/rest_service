import 'package:dio/dio.dart';
import 'package:rest_service/entities/request_errors.dart';
import 'package:rest_service/entities/rest_failure.dart';
import 'package:rest_service/entities/rest_response.dart';

import 'rest_service.dart';

class RestServiceImpl implements RestService {
  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(milliseconds: 20000),
    receiveTimeout: const Duration(milliseconds: 20000),
  ));

  RestServiceImpl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  void addInterceptor(Interceptor interceptor) =>
      _dio.interceptors.add(interceptor);

  void removeInterceptor(Interceptor interceptor) =>
      _dio.interceptors.remove(interceptor);

  @override
  Future<RestResponse<List<T>>> getList<T>(
    String path,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.get(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestResponse<List<T>>()
        ..data = _parseList(result.data, parse)
        ..statusCode = result.statusCode;
    } on DioException catch (err) {
      return RestResponse<List<T>>()
        ..failure = _getFailureFromDioException(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return RestResponse<List<T>>()..failure = RestFailure();
    }
  }

  @override
  Future<RestResponse<T>> getModel<T>(
    String path,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.get(path, queryParameters: query);
      return RestResponse<T>()
        ..data = parse(result.data)
        ..statusCode = result.statusCode;
    } on DioException catch (err) {
      return RestResponse<T>()
        ..failure = _getFailureFromDioException(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return RestResponse<T>()..failure = RestFailure();
    }
  }

  @override
  Future<RestResponse<List<T>>> postList<T>(
    String path,
    body,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.post(
        path,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestResponse<List<T>>()
        ..data = _parseList(result.data, parse)
        ..statusCode = result.statusCode;
    } on DioException catch (err) {
      return RestResponse<List<T>>()
        ..failure = _getFailureFromDioException(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return RestResponse<List<T>>()..failure = RestFailure();
    }
  }

  @override
  Future<RestResponse<T>> postModel<T>(
      String path, body, T Function(Map<String, dynamic>? json) parse) async {
    try {
      final result = await _dio.post(path, data: body);
      return RestResponse<T>()
        ..data = parse(result.data)
        ..statusCode = result.statusCode;
    } on DioException catch (err) {
      return RestResponse<T>()
        ..failure = _getFailureFromDioException(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return RestResponse<T>()..failure = RestFailure();
    }
  }

  @override
  Future<RestResponse<T>> putModel<T>(
      String path, body, T Function(dynamic json) parse) async {
    try {
      final result = await _dio.put(path, data: body);
      return RestResponse<T>()
        ..data = parse(result.data)
        ..statusCode = result.statusCode;
    } on DioException catch (err) {
      return RestResponse<T>()
        ..failure = _getFailureFromDioException(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return RestResponse<T>()..failure = RestFailure();
    }
  }

  //Esse tratamento de erro pode de ser revisado e mudado se preciso, add messagem da api etc
  RestFailure _getFailureFromDioException(DioException error) {
    if (error.response == null) {
      return RestFailure(requestErrors: RequestErrors.connectionError);
    }
    switch (error.response?.statusCode) {
      case 404:
        return RestFailure(requestErrors: RequestErrors.notFound);
      case 500:
        return RestFailure(requestErrors: RequestErrors.serverError);
      case 400:
      case 401:
        return RestFailure(requestErrors: RequestErrors.unauthorized);
      default:
        return RestFailure(message: 'Unknown');
    }
  }

  List<T> _parseList<T>(
          dynamic itens, T Function(Map<String, dynamic>? item) parse) =>
      (itens as List<dynamic>).map((e) => parse(e)).toList();
}
