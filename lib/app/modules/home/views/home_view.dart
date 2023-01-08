import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/controllers/page_index_controller.dart';
import 'package:quran/app/data/constant/colors.dart';
import 'package:quran/app/data/model/surah.dart';
import 'package:quran/app/data/reusable/navigation.dart';
import 'package:quran/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final PageIndexController pageController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quran App',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.SEARCH),
            icon: const Icon(Icons.search, size: 34.0),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Assalamualaikum",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GetBuilder<HomeController>(
                builder: (_) => FutureBuilder(
                  future: controller.getLastRead(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(colors: [appPurpleLight2, appPurpleLight1]),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            height: 150,
                            width: Get.width,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Image.asset('assets/img/quran.png'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/img/book.png'),
                                          const SizedBox(width: 10.0),
                                          const Text(
                                            "Last Read",
                                            style: TextStyle(
                                              color: appwhite,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Get.isDarkMode ? appwhite : appPurple,
                                        ),
                                      ),
                                      const Text(
                                        "",
                                        style: TextStyle(
                                          color: appwhite,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    Map<String, dynamic>? lastRead = snapshot.data;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(colors: [appPurpleLight2, appPurpleLight1]),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          // onTap: () => Get.toNamed(Routes.LAST_READ),
                          onLongPress: () {
                            if (lastRead != null) {
                              Get.defaultDialog(
                                  title: 'Delete last read',
                                  middleText: 'Are you sure want to delete last read?',
                                  actions: [
                                    ElevatedButton(onPressed: () => Get.back(), child: const Text("Cancel")),
                                    ElevatedButton(
                                        onPressed: () {
                                          controller.removeBookmark(lastRead['id']);
                                          Get.back();
                                        },
                                        child: const Text("Yes, Delete")),
                                  ]);
                            }
                          },
                          onTap: () {
                            if (lastRead != null) {
                              switch (lastRead['via']) {
                                case 'juz':
                                  int juz = int.parse(lastRead['surah'].toString().replaceAll("Juz ", ""));
                                  Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                                    'juz': juz,
                                    'bookmark': lastRead,
                                  });
                                  break;
                                default:
                                  Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                                    'name': lastRead['surah'].toString().replaceAll("+", "'"),
                                    'number': lastRead['number_surah'],
                                    'bookmark': lastRead,
                                  });
                                  break;
                              }
                            }
                          },
                          child: SizedBox(
                            height: 150,
                            width: Get.width,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Image.asset('assets/img/quran.png'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/img/book.png'),
                                          const SizedBox(width: 10.0),
                                          const Text(
                                            "Last Read",
                                            style: TextStyle(
                                              color: appwhite,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        lastRead == null
                                            ? "Last Read"
                                            : "${lastRead['surah'].toString().replaceAll('+', "'")}",
                                        style: const TextStyle(
                                          color: appwhite,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        lastRead == null
                                            ? "Last Read"
                                            : "Juz ${lastRead['juz']} | Ayat ${lastRead['ayat']}",
                                        style: const TextStyle(
                                          color: appwhite,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const TabBar(
                // indicatorColor: controller.isDark.isTrue ? appwhite : appPurple,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: 'Surah'),
                  Tab(text: 'Juz'),
                  Tab(text: 'Bookmark'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // SURAH
                    FutureBuilder(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: Get.isDarkMode ? appwhite : appPurple));
                        }
                        if (!snapshot.hasData) {
                          return const Center(child: Text("Tidak ada data"));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            Surah surah = snapshot.data![index];

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
                      },
                    ),

                    // JUZ
                    ListView.builder(
                      itemCount: 30,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        print('object');
                        // Surah surah = snapshot.data![index];

                        return GestureDetector(
                          onTap: () => Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                            'index': index + 1,
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
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              'Juz ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // BOOKMARK
                    GetBuilder<HomeController>(
                      builder: (_) {
                        return FutureBuilder(
                          future: controller.getBookmar(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(color: Get.isDarkMode ? appwhite : appPurple));
                            }
                            if (snapshot.data!.isEmpty) {
                              return const Center(child: Text("tidak ada data"));
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data = snapshot.data![index];
                                // print(data);

                                return ListTile(
                                  onTap: () {
                                    switch (data['via']) {
                                      case 'juz':
                                        int juz = int.parse(data['surah'].toString().replaceAll("Juz ", ""));
                                        Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                                          'juz': juz,
                                          'bookmark': data,
                                        });
                                        break;
                                      default:
                                        Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                                          'name': data['surah'].toString().replaceAll("+", "'"),
                                          'number': data['number_surah'],
                                          'bookmark': data,
                                        });
                                        break;
                                    }
                                  },
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
                                        '${data['ayat']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(data['surah'].toString().replaceAll("+", "'")),
                                  subtitle: Text("Ayat ${data['ayat']} - via ${data['via']}"),
                                  trailing: IconButton(
                                    color: Get.isDarkMode ? appwhite : appPurple,
                                    onPressed: () => controller.removeBookmark(data['id']),
                                    icon: const Icon(
                                      Icons.bookmark_remove_rounded,
                                      size: 24.0,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () => controller.changeThema(),
          // onPressed: () => controller.converDate(DateTime.now().toIso8601String()),
          child: controller.isDark.isTrue ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
        ),
      ),

      // BOTTOM NAVIGASI
      bottomNavigationBar: NavagationBar(
        controller: pageController.index.value,
        onChanged: (i) => pageController.changePage(i),
      ),
    );
  }
}
