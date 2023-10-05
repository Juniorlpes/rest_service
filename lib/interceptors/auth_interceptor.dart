import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Future<String> Function() token;
  final String? headerParameter;
  final bool bearerPrefixToken;

  AuthInterceptor(
    this.token, {
    this.headerParameter,
    this.bearerPrefixToken = true,
  });

  @override
  Future<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[headerParameter ?? 'Authorization'] =
        '${bearerPrefixToken ? 'Bearer ' : ''}${await token()}';
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
