import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zavisoft_hiring_task/app/data/providers/api_provider.dart';
import 'package:zavisoft_hiring_task/app/data/repositories/api_repository.dart';
import 'package:zavisoft_hiring_task/app/modules/cart/controllers/cart_controller.dart';
import 'package:zavisoft_hiring_task/app/routes/app_pages.dart';
import 'package:zavisoft_hiring_task/app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // register cart controller globally so it persists across all screens
  Get.put(
    CartController(
      repository: ApiRepository(provider: ApiProvider()),
    ),
    permanent: true,
  );

  final storage = GetStorage();
  final isLoggedIn = storage.hasData('auth_token');

  runApp(
    GetMaterialApp(
      title: 'Daraz Style App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF85606),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
    ),
  );
}
