import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/controllers/page_index_controller.dart';
import 'package:quran/app/data/constant/colors.dart';

import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();
  final pageController = Get.put(PageIndexController(), permanent: true);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: box.read('themaDark') == null ? themaLight : themaDark,
      darkTheme: themaDark,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
