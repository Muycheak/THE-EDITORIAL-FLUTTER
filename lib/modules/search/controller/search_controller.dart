import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/app/data/models/article.dart';
import 'package:news_app/app/data/models/repository_result.dart';
import 'package:news_app/app/data/repositories/news_repositories.dart';

class SearchController extends GetxController {
  final NewsRepositories _newsRepositories = NewsRepositories();

  bool _hasMore = true;

  RxBool isLoading = false.obs;
  RxBool isFetching = false.obs;
  RxString errorMessage = ''.obs;
  RxList<Article> articles = RxList<Article>();
  RxString searchQuery = ''.obs;
  late TextEditingController textEditingController;

  final ScrollController scrollController = ScrollController();

  int page = 2;
  int perPage = 10;

  @override
  Future<void> onInit() async {
    super.onInit();
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      searchQuery.value = textEditingController.text;
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading.value &&
          _hasMore) {
        loadMore();
      }
    });
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  Future<void> loadMore() async {
    if (isLoading.value || !_hasMore) return;
    try {
      isLoading.value = true;
      errorMessage.value = "";
      DateTime dateTime = DateTime.now();

      String yesterday =
          '${dateTime.year}-${dateTime.month}-${dateTime.day - 1}';
      String today = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

      final RepositoryResult repositoryResult = await _newsRepositories
          .getEverythingRepo(
            query: searchQuery.value,
            from: yesterday,
            to: today,
            page: 1,
            perPage: 10,
          );

      if (repositoryResult.isError) {
        errorMessage.value = repositoryResult.message;
      } else {
        if (repositoryResult.data.isEmpty) {
          _hasMore = false;
        } else {
          articles.addAll(repositoryResult.data);
          page++;
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchNews(String query) async {
    try {
      isFetching.value = true;
      isLoading.value = true;
      errorMessage.value = "";
      DateTime dateTime = DateTime.now();

      String yesterday =
          '${dateTime.year}-${dateTime.month}-${dateTime.day - 1}';
      String today = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

      final RepositoryResult repositoryResult = await _newsRepositories
          .getEverythingRepo(
            query: query,
            from: yesterday,
            to: today,
            page: 1,
            perPage: 10,
          );
      if (repositoryResult.isError) {
        errorMessage.value = repositoryResult.message;
      } else {
        articles.assignAll(repositoryResult.data);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
