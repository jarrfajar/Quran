import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran/app/data/constant/colors.dart';
import 'package:quran/app/data/model/detailsurah.dart' as detailModel;
import 'package:quran/app/modules/home/controllers/home_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  // Surah surah = Get.arguments;
  final homeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments['name'].toString()),
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                barrierDismissible: false,
                title: 'Font size',
                content: Column(
                  children: [
                    const Text("Arab"),
                    Obx(
                      () => SfSlider(
                        min: 10.0,
                        max: 40.0,
                        value: controller.fontArab.value,
                        interval: 10,
                        stepSize: 1.0,
                        showLabels: true,
                        enableTooltip: true,
                        onChanged: (dynamic value) {
                          controller.fontArab.value = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text("Translation"),
                    Obx(
                      () => SfSlider(
                        min: 10.0,
                        max: 40.0,
                        value: controller.fontTranslation.value,
                        interval: 10,
                        stepSize: 1.0,
                        // showTicks: true,
                        showLabels: true,
                        enableTooltip: true,
                        // minorTicksPerInterval: 1,
                        onChanged: (dynamic value) {
                          controller.fontTranslation.value = value;
                        },
                      ),
                    ),
                  ],
                ),
                cancel: ElevatedButton(
                  onPressed: () {
                    final box = GetStorage();
                    if (box.read('fontArab') != null) {
                      controller.fontArab.value = box.read('fontArab');
                    } else {
                      controller.fontArab.value = 26.0;
                    }

                    if (box.read('fontTranslation') != null) {
                      controller.fontTranslation.value = box.read('fontTranslation');
                    } else {
                      controller.fontTranslation.value = 26.0;
                    }

                    Get.back();
                  },
                  child: const Text("Cancel"),
                ),
                confirm: ElevatedButton(
                  onPressed: () {
                    final box = GetStorage();
                    if (box.read('fontArab') != null) {
                      box.remove('fontArab');
                    }
                    box.write('fontArab', controller.fontArab.value);

                    if (box.read('fontTranslation') != null) {
                      box.remove('fontTranslation');
                    }
                    box.write('fontTranslation', controller.fontTranslation.value);
                    Get.back();
                  },
                  child: const Text("Save"),
                ),
              );
            },
            icon: const Icon(Icons.text_format_rounded, size: 34.0),
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.getDetailSurah(Get.arguments['number'].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Get.isDarkMode ? appwhite : appPurple));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Tidak ada data"));
          }
          if (Get.arguments['bookmark'] != null) {
            bookmark = Get.arguments['bookmark'];

            controller.scrollController.scrollToIndex(
              bookmark!['index_ayat'] + 2,
              preferPosition: AutoScrollPosition.begin,
            );
          }
          detailModel.DetailSurah surah = snapshot.data!;

          List<Widget> allAyat = List.generate(
            snapshot.data?.verses?.length ?? 0,
            (index) {
              detailModel.Verses ayat = snapshot.data!.verses![index];

              return AutoScrollTag(
                key: ValueKey(index + 2),
                index: index + 2,
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    index == 0 && snapshot.data!.preBismillah != null
                        ? Center(
                            child: Obx(
                              () => Text(
                                snapshot.data!.preBismillah!.text!.arab!,
                                style: TextStyle(
                                  fontFamily: "LPMQ IsepMisbah",
                                  fontSize: controller.fontArab.value,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/img/octagonal.png"),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  ayat.number!.inSurah.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            GetBuilder<DetailSurahController>(
                              builder: (_) {
                                return Row(
                                  children: [
                                    ayat.kondisiAudio == 'stop'
                                        ? IconButton(
                                            onPressed: () => controller.playAudio(ayat),
                                            icon: const Icon(
                                              Icons.play_arrow_rounded,
                                              size: 24.0,
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              ayat.kondisiAudio == 'playing'
                                                  ? IconButton(
                                                      onPressed: () => controller.pauseAudio(ayat),
                                                      icon: const Icon(
                                                        Icons.pause,
                                                        size: 24.0,
                                                      ),
                                                    )
                                                  : IconButton(
                                                      onPressed: () => controller.resumeAudio(ayat),
                                                      icon: const Icon(
                                                        Icons.play_arrow,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                              IconButton(
                                                onPressed: () => controller.stopAudio(ayat),
                                                icon: const Icon(
                                                  Icons.stop,
                                                  size: 24.0,
                                                ),
                                              )
                                            ],
                                          ),

                                    // BOOKMARK
                                    IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: 'Bookmark',
                                          middleText: 'Pilih jenis bookmark',
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                await controller.bookmar(true, snapshot.data!, ayat, index);
                                                homeC.update();
                                              },
                                              child: const Text("Last Read"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => controller.bookmar(false, snapshot.data!, ayat, index),
                                              child: const Text("Bookmark"),
                                            ),
                                          ],
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.bookmark_outline_rounded,
                                        size: 24.0,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    // AYAT
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Obx(
                        () => GestureDetector(
                          onTap: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Tafsir'),
                                content: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Text(
                                      ayat.tafsir!.id!.long.toString(),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            ayat.text!.arab!,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontFamily: "LPMQ IsepMisbah",
                              // fontSize: 26.0,
                              fontSize: controller.fontArab.value,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Obx(
                        () => GestureDetector(
                          onTap: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Tafsir'),
                                content: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Text(
                                      ayat.tafsir!.id!.short.toString(),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            ayat.translation!.id!,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              // fontSize: 16.0,
                              fontSize: controller.fontTranslation.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              );
            },
          );

          return ListView(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(10),
            children: [
              AutoScrollTag(
                key: const ValueKey(0),
                index: 0,
                controller: controller.scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(colors: [
                        appPurpleLight2,
                        appPurpleLight1,
                      ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            surah.name!.transliteration!.id!,
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: appwhite,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            surah.name!.translation!.id!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: appwhite,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Divider(color: appwhite),
                          const SizedBox(height: 10.0),
                          Text(
                            "${surah.numberOfVerses} Ayat | ${surah.revelation!.id}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: appwhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AutoScrollTag(
                  key: const ValueKey(1),
                  index: 1,
                  controller: controller.scrollController,
                  child: const SizedBox(height: 20.0)),
              ...allAyat
            ],
          );
        },
      ),
    );
  }
}
