import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'Models/ArticleModel.dart';
import 'Models/NewsModel.dart';

class NewsController extends GetxController {
  List<ArticleModel> allNews = <ArticleModel>[];
  List<ArticleModel> breakingNews = <ArticleModel>[];
  ScrollController scrollController = ScrollController();

  RxBool articleNotFound = false.obs;
  RxBool isLoading = false.obs;
  RxString cName = ''.obs;
  RxString country = ''.obs;
  RxString category = ''.obs;
  RxString channel = ''.obs;
  RxString searchNews = ''.obs;
  RxInt pageNum = 1.obs;
  RxInt pageSize = 10.obs;
  String baseUrl = "https://newsapi.org/v2/top-headlines?";

  getAllNewsFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      NewsModel newsData = NewsModel.fromJson(jsonDecode(res.body));

      if (newsData.articles.isEmpty && newsData.totalResults == 0) {
        articleNotFound.value = isLoading.value == true ? false : true;
        isLoading.value = false;
        update();
      } else {
        if (isLoading.value == true) {
          allNews = [...allNews, ...newsData.articles];
          update();
        } else {
          if (newsData.articles.isNotEmpty) {
            allNews = newsData.articles;

            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            update();
          }
        }
        articleNotFound.value = false;
        isLoading.value = false;
        update();
      }
    } else {
      articleNotFound.value = true;
      update();
    }
  }

  getBreakingNewsFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      NewsModel newsData = NewsModel.fromJson(jsonDecode(res.body));

      if (newsData.articles.isEmpty && newsData.totalResults == 0) {
        articleNotFound.value = isLoading.value == true ? false : true;
        isLoading.value = false;
        update();
      } else {
        if (isLoading.value == true) {
          breakingNews = [...breakingNews, ...newsData.articles];
          update();
        } else {
          if (newsData.articles.isNotEmpty) {
            breakingNews = newsData.articles;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            update();
          }
        }
        articleNotFound.value = false;
        isLoading.value = false;
        update();
      }
    } else {
      articleNotFound.value = true;
      update();
    }
  }

  getAllNews({channel = '', searchKey = '', reload = false}) async {
    articleNotFound.value = false;

    if (!reload && isLoading.value == false) {
    } else {
      country.value = '';
      category.value = '';
    }
    if (isLoading.value == true) {
      pageNum++;
    } else {
      allNews = [];

      pageNum.value = 2;
    }

    baseUrl = "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&";

    baseUrl += country.isEmpty ? 'country=in&' : 'country=$country&';

    baseUrl += category.isEmpty ? 'category=business&' : 'category=$category&';
    baseUrl += 'apiKey=4ce96961add94ee68a3d4e7807a4ee26';

    if (channel != '') {
      country.value = '';
      category.value = '';
      baseUrl =
          "https://newsapi.org/v2/top-headlines?sources=$channel&apiKey=4ce96961add94ee68a3d4e7807a4ee26";
    }
    // when a enters any keyword the country and category will become null
    if (searchKey != '') {
      country.value = '';
      category.value = '';
      baseUrl =
          "https://newsapi.org/v2/everything?q=$searchKey&from=2022-07-01&sortBy=popularity&pageSize=10&apiKey=4ce96961add94ee68a3d4e7807a4ee26";
    }
    print(baseUrl);
    // calling the API function and passing the URL here
    getAllNewsFromApi(baseUrl);
  }

  getBreakingNews({reload = false}) async {
    articleNotFound.value = false;

    if (!reload && isLoading.value == false) {
    } else {
      country.value = '';
    }
    if (isLoading.value == true) {
      pageNum++;
    } else {
      breakingNews = [];

      pageNum.value = 2;
    }
    // default language is set to English
    /// ENDPOINT
    baseUrl =
        "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&languages=en&";
    // default country is set to US
    baseUrl += country.isEmpty ? 'country=us&' : 'country=$country&';
    //baseApi += category.isEmpty ? '' : 'category=$category&';
    baseUrl += 'apiKey=4ce96961add94ee68a3d4e7807a4ee26';
    print([baseUrl]);
    // calling the API function and passing the URL here
    getBreakingNewsFromApi(baseUrl);
  }

  @override
  void onInit() {
    scrollController = ScrollController()..addListener(_scrollListener);
    getAllNews();
    getBreakingNews();
    super.onInit();
  }

  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoading.value = true;
      getAllNews();
    }
  }
}
