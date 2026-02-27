import 'package:get/get.dart';
import 'package:zavisoft_hiring_task/app/data/models/product_model.dart';
import 'package:zavisoft_hiring_task/app/data/repositories/api_repository.dart';

// Manages cart state globally. Registered as permanent in main.dart
// so it persists across all screens without being tied to a route.
class CartController extends GetxController {
  final ApiRepository _repository;

  CartController({required ApiRepository repository})
      : _repository = repository;

  final cartItems = <ProductModel>[].obs;
  final Rxn<int> _currentCartId = Rxn<int>();

  int get itemCount => cartItems.length;

  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + item.price);

  Future<void> addToCart(ProductModel product) async {
    cartItems.add(product);
    // sync with FakeStore API (fire-and-forget since it's a fake backend)
    try {
      final cart = await _repository.addToCart(
        userId: 1,
        products: cartItems.toList(),
      );
      _currentCartId.value = cart.id;
    } catch (_) {}
  }

  Future<void> removeFromCart(int index) async {
    cartItems.removeAt(index);
    // call delete API with current cart ID (fire-and-forget)
    if (_currentCartId.value != null) {
      try {
        await _repository.deleteCart(_currentCartId.value!);
      } catch (_) {}
    }
  }

  Future<void> clearCart() async {
    cartItems.clear();
    // call delete API (fire-and-forget)
    if (_currentCartId.value != null) {
      try {
        await _repository.deleteCart(_currentCartId.value!);
        _currentCartId.value = null;
      } catch (_) {}
    }
  }
}
