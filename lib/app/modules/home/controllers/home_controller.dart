import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zavisoft_hiring_task/app/data/models/product_model.dart';
import 'package:zavisoft_hiring_task/app/data/repositories/api_repository.dart';

// Manages product data, categories, and the TabController.
// Does NOT touch scroll positions — that's NestedScrollView's job.
// Repository is injected via binding, not created here.
class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApiRepository _repository;

  HomeController({required ApiRepository repository})
      : _repository = repository;

  late TabController tabController;

  final productsByTab = <int, List<ProductModel>>{}.obs;
  final categories = <String>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final _allProducts = <ProductModel>[];

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await Future.wait([
        _repository.getCategories(),
        _repository.getAllProducts(),
      ]);

      final fetchedCategories = results[0] as List<String>;
      final fetchedProducts = results[1] as List<ProductModel>;

      _allProducts
        ..clear()
        ..addAll(fetchedProducts);

      categories.value = ['All', ...fetchedCategories];

      tabController = TabController(
        length: categories.length,
        vsync: this,
      );

      _organizeProducts();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load products. Pull down to retry.';
    }
  }

  void _organizeProducts() {
    final map = <int, List<ProductModel>>{};
    map[0] = List.from(_allProducts);

    for (int i = 1; i < categories.length; i++) {
      final category = categories[i];
      map[i] = _allProducts
          .where((p) => p.category == category)
          .toList();
    }

    productsByTab.value = map;
  }

  Future<void> refreshData() async {
    try {
      final results = await Future.wait([
        _repository.getCategories(),
        _repository.getAllProducts(),
      ]);

      final fetchedCategories = results[0] as List<String>;
      final fetchedProducts = results[1] as List<ProductModel>;

      _allProducts
        ..clear()
        ..addAll(fetchedProducts);

      final previousIndex = tabController.index;
      final newCategories = ['All', ...fetchedCategories];

      if (newCategories.length != categories.length) {
        tabController.dispose();
        categories.value = newCategories;
        tabController = TabController(
          length: categories.length,
          vsync: this,
          initialIndex: previousIndex.clamp(0, newCategories.length - 1),
        );
      }

      _organizeProducts();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<ProductModel> getProductsForTab(int tabIndex) {
    final products = productsByTab[tabIndex] ?? [];
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return products;
    return products
        .where((p) => p.title.toLowerCase().contains(query))
        .toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
