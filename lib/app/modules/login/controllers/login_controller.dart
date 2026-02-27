import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zavisoft_hiring_task/app/data/repositories/api_repository.dart';
import 'package:zavisoft_hiring_task/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final ApiRepository _repository;
  final _storage = GetStorage();

  LoginController({required ApiRepository repository})
      : _repository = repository;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isPasswordVisible = false.obs;
  String username = '';
  String password = '';

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      errorMessage.value = 'Please enter both username and password.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _repository.login(
        username: username.trim(),
        password: password.trim(),
      );

      _storage.write('auth_token', response.token);
      _storage.write('user_id', 1);

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      developer.log('Login error: $e', name: 'LoginController');
      errorMessage.value = 'Invalid username or password. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  bool get isAuthenticated => _storage.hasData('auth_token');
}
