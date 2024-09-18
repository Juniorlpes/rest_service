import 'package:dio/dio.dart';
import 'package:simple_rest_service/rest_service.dart';

abstract class RestService {
  late final Dio _dio;
  final String Function(dynamic)? getErrorMessage;
  late final String _baseUrl;

  //PermaQuery

  RestService(
    String baseUrl, {
    int timeoutMilliseconds = 20000,
    this.getErrorMessage,
  }) {
    _dio = Dio(BaseOptions(
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
      return RestResponse<List<T>>()
        ..data = _parseList(result.data, parse)
        ..restStatusCode = RestStatusCode.fromInt(result.statusCode);
    } on DioException catch (err) {
      return RestResponse<List<T>>()
        ..failure = _getFailureFromDioException(err)
        ..restStatusCode = RestStatusCode.fromInt(err.response?.statusCode);
    } catch (e) {
      return RestResponse<List<T>>()..failure = RestFailure();
    }
  }

  ///Get a model from webService
  Future<RestResponse<T>> getModel<T>(
    String path,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.get(_composeUrl(path), queryParameters: query);
      return RestResponse<T>()
        ..data = parse(result.data)
        ..restStatusCode = RestStatusCode.fromInt(result.statusCode);
    } on DioException catch (err) {
      return RestResponse<T>()
        ..failure = _getFailureFromDioException(err)
        ..restStatusCode = RestStatusCode.fromInt(err.response?.statusCode);
    } catch (e) {
      return RestResponse<T>()..failure = RestFailure();
    }
  }

  ///Post a data and receive a list model
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
      return RestResponse<List<T>>()
        ..data = _parseList(result.data, parse)
        ..restStatusCode = RestStatusCode.fromInt(result.statusCode);
    } on DioException catch (err) {
      return RestResponse<List<T>>()
        ..failure = _getFailureFromDioException(err)
        ..restStatusCode = RestStatusCode.fromInt(err.response?.statusCode);
    } catch (e) {
      return RestResponse<List<T>>()..failure = RestFailure();
    }
  }

  ///Post a data and receive a model
  Future<RestResponse<T>> postModel<T>(
      String path, body, T Function(Map<String, dynamic>? json) parse) async {
    try {
      final result = await _dio.post(_composeUrl(path), data: body);
      return RestResponse<T>()
        ..data = parse(result.data)
        ..restStatusCode = RestStatusCode.fromInt(result.statusCode);
    } on DioException catch (err) {
      return RestResponse<T>()
        ..failure = _getFailureFromDioException(err)
        ..restStatusCode = RestStatusCode.fromInt(err.response?.statusCode);
    } catch (e) {
      return RestResponse<T>()..failure = RestFailure();
    }
  }

  ///Put a data and receive a model
  Future<RestResponse<T>> putModel<T>(
      String path, body, T Function(dynamic json) parse) async {
    try {
      final result = await _dio.put(_composeUrl(path), data: body);
      return RestResponse<T>()
        ..data = parse(result.data)
        ..restStatusCode = RestStatusCode.fromInt(result.statusCode);
    } on DioException catch (err) {
      return RestResponse<T>()
        ..failure = _getFailureFromDioException(err)
        ..restStatusCode = RestStatusCode.fromInt(err.response?.statusCode);
    } catch (e) {
      return RestResponse<T>()..failure = RestFailure();
    }
  }

  //Esse tratamento de erro pode de ser revisado e mudado se preciso, add messagem da api etc
  RestFailure _getFailureFromDioException(DioException error) {
    if (error.response == null) {
      return RestFailure(message: 'connectionError');
    }
    return RestFailure(
      message:
          error.message ?? getErrorMessage?.call(error.response?.data) ?? '',
    );
    // switch (error.response?.statusCode) {
    //   case 404:
    //     return RestFailure(requestErrors: RequestErrors.notFound);
    //   case 500:
    //     return RestFailure(requestErrors: RequestErrors.serverError);
    //   case 400:
    //   case 401:
    //     return RestFailure(requestErrors: RequestErrors.unauthorized);
    //   default:
    //     return RestFailure(message: 'Unknown');
    // }
  }

  String _composeUrl(String path) =>
      '$_baseUrl/${path.startsWith('/') ? path.substring(1) : path}';

  List<T> _parseList<T>(
          dynamic itens, T Function(Map<String, dynamic>? item) parse) =>
      (itens as List<dynamic>).map((e) => parse(e)).toList();
}
