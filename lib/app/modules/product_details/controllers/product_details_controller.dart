import 'package:get/get.dart';
import 'package:zavisoft_hiring_task/app/data/models/product_model.dart';
import 'package:zavisoft_hiring_task/app/data/repositories/api_repository.dart';

class ProductDetailsController extends GetxController {
  final ApiRepository _repository;

  ProductDetailsController({required ApiRepository repository})
      : _repository = repository;

  final Rxn<ProductModel> product = Rxn<ProductModel>();
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final productId = Get.arguments as int;
    _loadProduct(productId);
  }

  Future<void> _loadProduct(int productId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fetchedProduct = await _repository.getProduct(productId);
      product.value = fetchedProduct;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load product details.';
    }
  }

  Future<void> retry() async {
    final productId = Get.arguments as int;
    await _loadProduct(productId);
  }
}
