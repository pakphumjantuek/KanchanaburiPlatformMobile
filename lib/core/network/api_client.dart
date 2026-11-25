import 'package:get/get.dart';
import '../../app/config/api_config.dart';

class ApiClient extends GetConnect {
  String? authToken;

  @override
  void onInit() {
    httpClient.baseUrl = ApiConfig.baseUrl;
    httpClient.timeout = ApiConfig.connectTimeout;

    httpClient.addRequestModifier<dynamic>((request) {
      if (authToken != null && authToken!.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }
      return request;
    });

    super.onInit();
  }

  void setToken(String? token) {
    authToken = token;
  }
}
