import 'package:get/get.dart';
import 'package:zavisoft_hiring_task/app/modules/home/bindings/home_binding.dart';
import 'package:zavisoft_hiring_task/app/modules/home/views/home_view.dart';
import 'package:zavisoft_hiring_task/app/modules/login/bindings/login_binding.dart';
import 'package:zavisoft_hiring_task/app/modules/login/views/login_view.dart';
import 'package:zavisoft_hiring_task/app/modules/product_details/bindings/product_details_binding.dart';
import 'package:zavisoft_hiring_task/app/modules/product_details/views/product_details_view.dart';
import 'package:zavisoft_hiring_task/app/modules/profile/bindings/profile_binding.dart';
import 'package:zavisoft_hiring_task/app/modules/profile/views/profile_view.dart';
import 'package:zavisoft_hiring_task/app/routes/app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
