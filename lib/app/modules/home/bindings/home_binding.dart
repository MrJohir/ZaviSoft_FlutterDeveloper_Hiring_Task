import 'package:get/get.dart';
import 'package:zavisoft_hiring_task/app/data/providers/api_provider.dart';
import 'package:zavisoft_hiring_task/app/data/repositories/api_repository.dart';
import 'package:zavisoft_hiring_task/app/modules/home/controllers/home_controller.dart';

// DI wiring for home screen. Provider -> Repository -> Controller.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<ApiRepository>(
      () => ApiRepository(provider: Get.find<ApiProvider>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(repository: Get.find<ApiRepository>()),
    );
  }
}
