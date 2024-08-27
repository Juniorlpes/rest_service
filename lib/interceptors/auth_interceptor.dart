import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Future<String> Function() getToken;
  final String? authHeaderParameter;
  final bool bearerPrefixToken;

  AuthInterceptor(
    this.getToken, {
    this.authHeaderParameter,
    this.bearerPrefixToken = true,
  });

  @override
  Future<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[authHeaderParameter ?? 'Authorization'] =
        '${bearerPrefixToken ? 'Bearer ' : ''}${await getToken()}';
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // pode retornar o erro ou tentar tratar, direcionar pra login se token tiver expirado, fazer refreshToken etc
    return handler.next(err);
  }
}
