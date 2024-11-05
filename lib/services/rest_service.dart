import 'package:dio/dio.dart';
import 'package:simple_rest_service/rest_service.dart';

abstract class RestService implements IRestService {
  late final Dio _dio;
  final String? Function(dynamic)? getErrorMessage;
  late final String _baseUrl;

  //PermaQuery?
  //PermaHeaders?

  RestService(
    String baseUrl, {
    int timeoutMilliseconds = 20000,
    this.getErrorMessage,
    Dio? dioClient,
  }) {
    _dio = dioClient ??
        Dio(BaseOptions(
          connectTimeout: Duration(milliseconds: timeoutMilliseconds),
          receiveTimeout: Duration(milliseconds: timeoutMilliseconds),
          //baseUrl: baseUrl,
        ));
    _baseUrl = baseUrl.length < 3
        ? baseUrl
        : baseUrl.endsWith('/')
            ? baseUrl.substring(0, baseUrl.length - 2)
            : baseUrl;
  }

  void addInterceptor(Interceptor dioInterceptor) =>
      _dio.interceptors.add(dioInterceptor);

  void removeInterceptor(Interceptor dioInterceptor) =>
      _dio.interceptors.remove(dioInterceptor);

  ///Get a list model from webService
  @override
  Future<RestResponse<List<T>>> getList<T>(
    String path,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.get(
        _composeUrl(path),
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestSuccesResponse<List<T>>(
        data: _parseList(result.data, parse),
        restStatusCode: RestStatusCode.fromInt(result.statusCode),
      );
    } on DioException catch (err) {
      return _getRestExceptionFromDioException<List<T>>(err);
    } catch (e) {
      return RestException(
        restStatusCode: RestStatusCode.unknow,
        message: e.toString(),
      );
    }
  }

  ///Get a model from webService
  @override
  Future<RestResponse<T>> getModel<T>(
    String path,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.get(_composeUrl(path), queryParameters: query);

      return RestSuccesResponse<T>(
        data: parse(result.data),
        restStatusCode: RestStatusCode.fromInt(result.statusCode),
      );
    } on DioException catch (err) {
      return _getRestExceptionFromDioException<T>(err);
    } catch (e) {
      return RestException(
        restStatusCode: RestStatusCode.unknow,
        message: e.toString(),
      );
    }
  }

  ///Post a data and receive a list model
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
        _composeUrl(path),
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestSuccesResponse<List<T>>(
        data: _parseList(result.data, parse),
        restStatusCode: RestStatusCode.fromInt(result.statusCode),
      );
    } on DioException catch (err) {
      return _getRestExceptionFromDioException<List<T>>(err);
    } catch (e) {
      return RestException(
        restStatusCode: RestStatusCode.unknow,
        message: e.toString(),
      );
    }
  }

  ///Post a data and receive a model
  @override
  Future<RestResponse<T>> postModel<T>(
    String path,
    body,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.post(
        _composeUrl(path),
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestSuccesResponse<T>(
        data: parse(result.data),
        restStatusCode: RestStatusCode.fromInt(result.statusCode),
      );
    } on DioException catch (err) {
      return _getRestExceptionFromDioException<T>(err);
    } catch (e) {
      return RestException(
        restStatusCode: RestStatusCode.unknow,
        message: e.toString(),
      );
    }
  }

  ///Put a data and receive a model
  @override
  Future<RestResponse<T>> putModel<T>(
    String path,
    body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.put(
        _composeUrl(path),
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestSuccesResponse<T>(
        data: parse(result.data),
        restStatusCode: RestStatusCode.fromInt(result.statusCode),
      );
    } on DioException catch (err) {
      return _getRestExceptionFromDioException<T>(err);
    } catch (e) {
      return RestException(
        restStatusCode: RestStatusCode.unknow,
        message: e.toString(),
      );
    }
  }

  @override
  Future<RestResponse<List<T>>> putList<T>(
    String path,
    body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.put(
        _composeUrl(path),
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestSuccesResponse<List<T>>(
        data: _parseList(result.data, parse),
        restStatusCode: RestStatusCode.fromInt(result.statusCode),
      );
    } on DioException catch (err) {
      return _getRestExceptionFromDioException<List<T>>(err);
    } catch (e) {
      return RestException(
        restStatusCode: RestStatusCode.unknow,
        message: e.toString(),
      );
    }
  }

  @override
  Future<RestResponse<void>> deleteModel(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result =
          await _dio.delete(_composeUrl(path), queryParameters: query);

      return RestSuccesResponse(
        data: null,
        restStatusCode: RestStatusCode.fromInt(result.statusCode),
      );
    } on DioException catch (err) {
      return _getRestExceptionFromDioException<void>(err);
    } catch (e) {
      return RestException(
        restStatusCode: RestStatusCode.unknow,
        message: e.toString(),
      );
    }
  }

  RestException<T> _getRestExceptionFromDioException<T>(
          DioException dioException) =>
      RestException<T>(
        restStatusCode:
            RestStatusCode.fromInt(dioException.response?.statusCode),
        stackTrace: dioException.stackTrace,
        dataResponse: dioException.response?.data,
        message: getErrorMessage != null
            ? getErrorMessage!.call(dioException.response?.data)
            : dioException.response == null
                ? 'connectionError'
                : dioException.message,
      );

  String _composeUrl(String path) =>
      '$_baseUrl/${path.startsWith('/') ? path.substring(1) : path}';

  List<T> _parseList<T>(
          dynamic itens, T Function(Map<String, dynamic>? item) parse) =>
      (itens as List<dynamic>).map((e) => parse(e)).toList();
}
