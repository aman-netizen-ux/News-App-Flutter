import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dropdown_list.dart';
import 'news_controller.dart';

Drawer sideDrawer(NewsController newsController) {
  var listOfCountry = [
    {"name": "INDIA", "code": "in"},
    {"name": "USA", "code": "us"},
    {"name": "UK", "code": "gb"},
    {"name": "MEXICO", "code": "mx"},
    {"name": "United Arab Emirates", "code": "ae"},
    {"name": "New Zealand", "code": "nz"},
    {"name": "Australia", "code": "au"},
    {"name": "Canada", "code": "ca"},
  ];

  var listOfCategory = [
    {"name": "Science", "code": "science"},
    {"name": "Business", "code": "business"},
    {"name": "Technology", "code": "technology"},
    {"name": "Sports", "code": "sports"},
    {"name": "Health", "code": "health"},
    {"name": "General", "code": "general"},
    {"name": "Entertainment", "code": "entertainment"},
    {"name": "ALL", "code": null},
  ];

  var listOfNewsChannel = [
    {"name": "BBC News", "code": "bbc-news"},
    {"name": "ABC News", "code": "abc-news"},
    {"name": "The Times of India", "code": "the-times-of-india"},
    {"name": "ESPN Cricket", "code": "espn-cric-info"},
    {"code": "politico", "name": "Politico"},
    {"code": "the-washington-post", "name": "The Washington Post"},
    {"code": "reuters", "name": "Reuters"},
    {"code": "cnn", "name": "cnn"},
    {"code": "nbc-news", "name": "NBC news"},
    {"code": "the-hill", "name": "The Hill"},
    {"code": "fox-news", "name": "Fox News"},
  ];

  return Drawer(
    backgroundColor: const Color(0xFFd2d7df),
    child: ListView(
      children: <Widget>[
        GetBuilder<NewsController>(
          builder: (controller) {
            return Container(
              decoration: const BoxDecoration(
                  color: Color(0xFF880d1e),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.cName.isNotEmpty
                      ? Text(
                          "Country: ${controller.cName.value.toUpperCase()}",
                          style: const TextStyle(
                              color: Color(0xFFf5f5f5), fontSize: 18),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 5.0),
                  controller.category.isNotEmpty
                      ? Text(
                          "Category: ${controller.category.value.capitalizeFirst}",
                          style: const TextStyle(
                              color: Color(0xFFf5f5f5), fontSize: 18),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 5.0),
                  controller.channel.isNotEmpty
                      ? Text(
                          "Category: ${controller.channel.value.capitalizeFirst}",
                          style: const TextStyle(
                              color: Color(0xFFf5f5f5), fontSize: 18),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            );
          },
          init: NewsController(),
        ),

        /// For Selecting the Country
        ExpansionTile(
          collapsedTextColor: Color(0xFF880d1e),
          collapsedIconColor: Color(0xFF880d1e),
          iconColor: Color(0xFF880d1e),
          textColor: Color(0xFF880d1e),
          title: const Text("Select Country"),
          children: <Widget>[
            for (int i = 0; i < listOfCountry.length; i++)
              drawerDropDown(
                onCalled: () {
                  newsController.country.value = listOfCountry[i]['code']!;
                  newsController.cName.value =
                      listOfCountry[i]['name']!.toUpperCase();
                  newsController.getAllNews();
                  newsController.getBreakingNews();
                },
                name: listOfCountry[i]['name']!.toUpperCase(),
              ),
          ],
        ),

        /// For Selecting the Category
        ExpansionTile(
          collapsedTextColor: Color(0xFF880d1e),
          collapsedIconColor: Color(0xFF880d1e),
          iconColor: Color(0xFF880d1e),
          textColor: Color(0xFF880d1e),
          title: const Text("Select Category"),
          children: [
            for (int i = 0; i < listOfCategory.length; i++)
              drawerDropDown(
                  onCalled: () {
                    newsController.category.value = listOfCategory[i]['code']!;
                    newsController.getAllNews();
                  },
                  name: listOfCategory[i]['name']!.toUpperCase())
          ],
        ),

        /// For Selecting the Channel
        ExpansionTile(
          collapsedTextColor: Color(0xFF880d1e),
          collapsedIconColor: Color(0xFF880d1e),
          iconColor: Color(0xFF880d1e),
          textColor: Color(0xFF880d1e),
          title: const Text("Select Channel"),
          children: [
            for (int i = 0; i < listOfNewsChannel.length; i++)
              drawerDropDown(
                onCalled: () {
                  newsController.channel.value = listOfNewsChannel[i]['code']!;
                  newsController.getAllNews(
                      channel: listOfNewsChannel[i]['code']);
                  newsController.cName.value = '';
                  newsController.category.value = '';
                  newsController.update();
                },
                name: listOfNewsChannel[i]['name']!.toUpperCase(),
              ),
          ],
        ),
        const Divider(),
        ListTile(
            trailing: const Icon(
              Icons.done_sharp,
              size: 28,
              color: Colors.black,
            ),
            title: const Text(
              "Done",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () => Get.back()),
      ],
    ),
  );
}
