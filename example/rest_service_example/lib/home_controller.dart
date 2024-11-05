import 'package:rest_service_example/ip_api.dart';
import 'package:rest_service_example/ip_model.dart';

class HomeController {
  final IPRestApi ipRestApi = IPRestApi();

  IPModel? ipModel;

  Future<void> getIPData() async {
    final result = await ipRestApi.getModel(
      '/json',
      (json) => IPModel.fromMap(json!),
    );

    ipModel = result.success ? result.data : null;
  }
}
