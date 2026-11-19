import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:news_app/app/data/models/article.dart';
import 'package:news_app/app/core/themes/app_colors.dart';
import 'package:news_app/app/core/constants/app_sizes.dart';
import 'package:news_app/app/core/themes/app_text_size.dart';
import 'package:news_app/app/core/themes/app_textstyles.dart';
import 'package:news_app/app/core/widgets/app_news_list_widget.dart';
import 'package:news_app/modules/home/widgets/home_shimmer_widget.dart';
import 'package:news_app/modules/trending/controller/trending_controller.dart';

class TrendingScreen extends GetView<TrendingController> {
  const TrendingScreen({super.key});

  Widget _shimmerLoading({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () => Get.back(),
          color: AppColor.primaryColor,
        ),
        centerTitle: true,
        title: Text(
          controller.selectCategories.isEmpty
              ? 'TRENDING NEWS'
              : controller.selectCategories.toUpperCase(),
          style: AppTextstyles.headline.copyWith(fontSize: AppTextSize.header1),
        ),
        elevation: 0.5,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.articles.isEmpty) {
          return _shimmerLoading(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding,
                vertical: AppSizes.verticalSpaceLarge,
              ),
              itemCount: 3,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.verticalSpaceXLarge),
              itemBuilder: (context, index) => const BreakingNewsShimmer(),
            ),
          );
        }
        if (controller.articles.isEmpty && controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.horizontalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: controller.loadMore,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }
        if (controller.articles.isEmpty) {
          return const Center(child: Text('No articles found'));
        }
        return ListView.separated(
          controller: controller.scrollController,
          itemCount:
              controller.articles.length + (controller.isLoading.value ? 1 : 0),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPadding,
            vertical: AppSizes.verticalSpaceLarge,
          ),
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSizes.verticalSpaceXLarge),
          itemBuilder: (context, index) {
            if (index == controller.articles.length) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: AppSizes.verticalSpaceLarge,
                ),
                child: const BreakingNewsShimmer(),
              );
            }
            final Article article = controller.articles[index];
            return AppNewsListWidget(article: article);
          },
        );
      }),
    );
  }
}
