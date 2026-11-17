import 'package:get/get.dart';
import 'package:news_app/modules/article_details/controller/article_details_controller.dart';

class ArticleDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleDetailsController>(
      () => ArticleDetailsController(),
      fenix: true,
    );
  }
}
