import 'package:dio/dio.dart';

///This interceptor is used to authenticate requests.
///
///The [getToken] parameter is a function that returns the token for authentication. [isBearerPrefixToken] indicates whether the authentication header is the Bearer token by default (default true). If it is not, you must indicate the header in [authHeaderParameter].
///
///If [refreshToken] is passed, it will be executed after receiving a 401 from the REST API.
class AuthInterceptor extends Interceptor {
  final Future<String> Function() getToken;
  final String? authHeaderParameter;
  final bool isBearerPrefixToken;
  final Future<void> Function()? refreshToken;

  AuthInterceptor({
    required this.getToken,
    this.authHeaderParameter,
    this.isBearerPrefixToken = true,
    this.refreshToken,
  });

  @override
  Future<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[authHeaderParameter ?? 'Authorization'] =
        '${isBearerPrefixToken ? 'Bearer ' : ''}${await getToken()}';
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // pode retornar o erro ou tentar tratar, direcionar pra login se token tiver expirado, fazer refreshToken etc

    if (err.response?.statusCode == 401 && refreshToken != null) {
      await refreshToken!();
    }

    return handler.next(err);
  }
}
