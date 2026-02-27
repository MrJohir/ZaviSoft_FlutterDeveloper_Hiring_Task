import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zavisoft_hiring_task/app/modules/home/controllers/home_controller.dart';
import 'package:zavisoft_hiring_task/app/modules/home/views/widgets/product_grid_tab.dart';
import 'package:zavisoft_hiring_task/app/modules/home/views/widgets/home_banner.dart';

// Main product listing screen.
// NestedScrollView handles all vertical scrolling (header collapse + tab content).
// TabBarView handles horizontal swipe between category tabs.
// These two never conflict because Flutter's gesture arena resolves
// drag direction before committing — H and V axes stay separate.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return _buildNestedScrollView(context);
      }),
    );
  }

  // Layout constants — named to document intent, not magic numbers.
  static const double _headerExpandedHeight = 180.0;
  static const Color _brandColor = Color(0xFFF85606);

  Widget _buildNestedScrollView(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              expandedHeight: _headerExpandedHeight,
              floating: true,
              snap: true,
              pinned: true,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: const FlexibleSpaceBar(
                background: HomeBanner(),
                collapseMode: CollapseMode.pin,
              ),
              backgroundColor: _brandColor,
              foregroundColor: Colors.white,
             
              bottom: TabBar(
                controller: controller.tabController,
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabAlignment: TabAlignment.start,
                tabs: controller.categories
                    .map((cat) => Tab(
                          text: cat[0].toUpperCase() + cat.substring(1),
                        ))
                    .toList(),
              ),
            ),
          ),
        ];
      },
      body: Builder(
        builder: (context) {
          // get pinned header height so refresh spinner shows below the tab bar
          final overlap = NestedScrollView
              .sliverOverlapAbsorberHandleFor(context)
              .layoutExtent ?? 0;
          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: _brandColor,
            edgeOffset: overlap,
            displacement: 80,
            // depth 1 because scroll events pass through TabBarView's PageView
            notificationPredicate: (notification) => notification.depth == 1,
            child: TabBarView(
              controller: controller.tabController,
              children: List.generate(
                controller.categories.length,
                (index) => ProductGridTab(
                  key: PageStorageKey<int>(index),
                  tabIndex: index,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
