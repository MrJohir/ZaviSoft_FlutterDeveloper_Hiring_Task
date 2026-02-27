import 'package:get/get.dart';
import 'package:zavisoft_hiring_task/app/data/providers/api_provider.dart';
import 'package:zavisoft_hiring_task/app/data/repositories/api_repository.dart';
import 'package:zavisoft_hiring_task/app/modules/login/controllers/login_controller.dart';

// DI wiring for login screen.
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<ApiRepository>(
      () => ApiRepository(provider: Get.find<ApiProvider>()),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(repository: Get.find<ApiRepository>()),
    );
  }
}
