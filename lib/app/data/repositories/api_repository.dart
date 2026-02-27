import 'package:zavisoft_hiring_task/app/data/models/cart_model.dart';
import 'package:zavisoft_hiring_task/app/data/models/login_response_model.dart';
import 'package:zavisoft_hiring_task/app/data/models/product_model.dart';
import 'package:zavisoft_hiring_task/app/data/models/user_model.dart';
import 'package:zavisoft_hiring_task/app/data/providers/api_provider.dart';

class ApiRepository {
  final ApiProvider _provider;

  ApiRepository({ApiProvider? provider}) : _provider = provider ?? ApiProvider();

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final json = await _provider.login(
      username: username,
      password: password,
    );
    return LoginResponseModel.fromJson(json);
  }

  Future<List<ProductModel>> getAllProducts() async {
    final jsonList = await _provider.fetchAllProducts();
    return jsonList
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProduct(int productId) async {
    final json = await _provider.fetchSingleProduct(productId);
    return ProductModel.fromJson(json);
  }

  Future<List<String>> getCategories() async {
    final jsonList = await _provider.fetchCategories();
    return jsonList.map((e) => e.toString()).toList();
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final jsonList = await _provider.fetchProductsByCategory(category);
    return jsonList
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UserModel> getUser(int userId) async {
    final json = await _provider.fetchUser(userId);
    return UserModel.fromJson(json);
  }

  Future<CartModel> addToCart({
    required int userId,
    required List<ProductModel> products,
  }) async {
    final json = await _provider.addToCart(
      userId: userId,
      products: products.map((p) => p.toJson()).toList(),
    );
    return CartModel.fromJson(json);
  }

  Future<List<CartModel>> getAllCarts() async {
    final jsonList = await _provider.fetchAllCarts();
    return jsonList
        .map((e) => CartModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteCart(int cartId) async {
    await _provider.deleteCart(cartId);
  }
}
