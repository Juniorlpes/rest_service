import 'package:simple_rest_service/rest_service.dart';

class IPRestApi extends RestService {
  IPRestApi()
      : super(
          'http://ip-api.com',
        ) {
    addInterceptor(PrintLogInterceptor());
  }
}
