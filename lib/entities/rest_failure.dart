///This class has commoms API services errors to avoid repetition on modules failures
class RestFailure implements Exception {
  String? message;

  RestFailure({this.message});
}
