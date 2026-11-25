import 'package:get/get.dart';
import '../../features/auth/models/user_model.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../network/api_client.dart';

class AuthService extends GetxService {
  final isLoggedIn = false.obs;
  final currentUser = Rxn<UserModel>();
  final token = RxnString();

  final AuthRepository _authRepository = AuthRepository();
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<AuthService> init() async {
    return this;
  }

  void setSession(String accessToken, UserModel user) {
    token.value = accessToken;
    currentUser.value = user;
    isLoggedIn.value = true;
    _apiClient.setToken(accessToken);
  }

  Future<void> refreshProfile() async {
    if (token.value == null || token.value!.isEmpty) return;
    final profile = await _authRepository.fetchProfile();
    if (profile != null) {
      currentUser.value = profile;
    }
  }

  void logout() {
    token.value = null;
    currentUser.value = null;
    isLoggedIn.value = false;
    _apiClient.setToken(null);
  }
}
