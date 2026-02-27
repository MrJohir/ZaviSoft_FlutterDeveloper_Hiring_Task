import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zavisoft_hiring_task/app/data/models/user_model.dart';
import 'package:zavisoft_hiring_task/app/data/repositories/api_repository.dart';
import 'package:zavisoft_hiring_task/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final ApiRepository _repository;
  final _storage = GetStorage();

  ProfileController({required ApiRepository repository})
      : _repository = repository;

  final Rxn<UserModel> user = Rxn<UserModel>();
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = _storage.read<int>('user_id') ?? 1;
      final fetchedUser = await _repository.getUser(userId);
      user.value = fetchedUser;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load profile.';
    }
  }

  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  void logout() {
    _storage.erase();
    Get.offAllNamed(AppRoutes.login);
  }
}
