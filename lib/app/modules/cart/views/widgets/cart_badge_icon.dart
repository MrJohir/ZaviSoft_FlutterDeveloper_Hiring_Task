import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zavisoft_hiring_task/app/modules/cart/controllers/cart_controller.dart';
import 'package:zavisoft_hiring_task/app/modules/cart/views/widgets/cart_bottom_sheet.dart';

// Reusable cart icon with item count badge.
// Used in both HomeView and ProductDetailsView app bars.
class CartBadgeIcon extends StatelessWidget {
  const CartBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return IconButton(
      icon: Obx(() {
        final count = cartController.itemCount;
        return Badge(
          isLabelVisible: count > 0,
          label: Text(
            '$count',
            style: const TextStyle(fontSize: 10),
          ),
          child:  Icon(Icons.shopping_cart_outlined,color: Colors.white,),
        );
      }),
      onPressed: () => showCartBottomSheet(context),
      tooltip: 'Cart',
    );
  }
}
