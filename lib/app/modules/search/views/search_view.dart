import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/data/constant/colors.dart';
import 'package:quran/app/data/model/surah.dart';
import 'package:quran/app/routes/app_pages.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                // color: Colors.grey[200],
                border: Border.all(color: Get.isDarkMode ? appwhite : appPurple),
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      // color: appwhite,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: null,
                      autofocus: true,
                      decoration: InputDecoration.collapsed(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: "search...",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        ),
                        hoverColor: Colors.transparent,
                      ),
                      onChanged: (value) {
                        controller.searchSurah(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // SURAH
          Expanded(
            child: Obx(() {
              if (controller.isLoading.isTrue) {
                return Center(child: CircularProgressIndicator(color: Get.isDarkMode ? appwhite : appPurple));
              }
              //
              return ListView.builder(
                // itemCount: controller.surah.length,
                itemCount: controller.search.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  Surah surah = controller.search[index];

                  return GestureDetector(
                    onTap: () => Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                      'name': surah.name!.transliteration!.id,
                      'number': surah.number,
                    }),
                    child: ListTile(
                      leading: Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/img/octagonal.png"),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            surah.number.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        surah.name!.transliteration!.id!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Text(
                        '${surah.revelation!.id} | ${surah.numberOfVerses} Ayat',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                      trailing: Text(
                        surah.name!.short!,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: "LPMQ IsepMisbah",
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          //
        ],
      ),
    );
  }
}
