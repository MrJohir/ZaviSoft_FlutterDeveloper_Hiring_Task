import 'package:zavisoft_hiring_task/app/data/models/product_model.dart';

class CartModel {
  final int id;
  final int userId;
  final List<ProductModel> products;

  CartModel({
    required this.id,
    required this.userId,
    required this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
