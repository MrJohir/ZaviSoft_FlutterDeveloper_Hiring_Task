import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zavisoft_hiring_task/app/modules/home/controllers/home_controller.dart';
import 'package:zavisoft_hiring_task/app/modules/home/views/widgets/product_card.dart';

// Each tab's content. Uses CustomScrollView that plugs into
// NestedScrollView's scroll chain (not an independent scrollable).
// SliverOverlapInjector reserves space for the pinned header,
// PageStorageKey keeps scroll position when switching tabs.
class ProductGridTab extends StatelessWidget {
  // Grid layout constants — named to avoid magic numbers.
  static const int _crossAxisCount = 2;
  static const double _childAspectRatio = 0.65;
  static const double _gridPadding = 8.0;

  final int tabIndex;

  const ProductGridTab({
    super.key,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Builder(
      builder: (BuildContext context) {
        return CustomScrollView(
          key: PageStorageKey<String>('tab_$tabIndex'),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            Obx(() {
              final products = controller.getProductsForTab(tabIndex);

              if (products.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No products found',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(_gridPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    childAspectRatio: _childAspectRatio,
                    crossAxisSpacing: _gridPadding,
                    mainAxisSpacing: _gridPadding,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(product: products[index]),
                    childCount: products.length,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
