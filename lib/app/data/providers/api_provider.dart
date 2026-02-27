import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class ApiProvider {
  static const String _baseUrl = 'https://fakestoreapi.com';
  static const Duration _timeout = Duration(seconds: 30);

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(_timeout);

      developer.log(
        'Login response: ${response.statusCode}',
        name: 'ApiProvider',
      );

      // Accepts both 200 and 201 since FakeStore login returns 201.
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        throw Exception('Unexpected response format: ${response.body}');
      } else {
        throw Exception(
          'Login failed (${response.statusCode}): ${response.body}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please check your connection.');
    } catch (e) {
      developer.log('Login exception: $e', name: 'ApiProvider');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchAllProducts() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch products (${response.statusCode})');
    }
  }

  Future<Map<String, dynamic>> fetchSingleProduct(int productId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products/$productId'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Failed to fetch product $productId (${response.statusCode})',
      );
    }
  }

  Future<List<dynamic>> fetchCategories() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products/categories'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch categories (${response.statusCode})');
    }
  }

  Future<List<dynamic>> fetchProductsByCategory(String category) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products/category/$category'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception(
        'Failed to fetch products for $category (${response.statusCode})',
      );
    }
  }

  Future<Map<String, dynamic>> fetchUser(int userId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/users/$userId'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch user (${response.statusCode})');
    }
  }

  Future<Map<String, dynamic>> addToCart({
    required int userId,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/carts'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'userId': userId,
              'products': products,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to add to cart (${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception('Request timed out.');
    }
  }

  Future<List<dynamic>> fetchAllCarts() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/carts'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch carts (${response.statusCode})');
    }
  }

  Future<Map<String, dynamic>> deleteCart(int cartId) async {
    final response = await http
        .delete(Uri.parse('$_baseUrl/carts/$cartId'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to delete cart (${response.statusCode})');
    }
  }
}
