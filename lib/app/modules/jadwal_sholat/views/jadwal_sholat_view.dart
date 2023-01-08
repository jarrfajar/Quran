import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran/app/controllers/page_index_controller.dart';
import 'package:quran/app/data/constant/colors.dart';
import 'package:quran/app/data/reusable/navigation.dart';
import 'package:quran/app/data/reusable/timeline.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:intl/intl.dart';
import 'package:quran/app/data/model/jadwalsholat.dart' as modelJadwalSholat;

import '../controllers/jadwal_sholat_controller.dart';

class JadwalSholatView extends GetView<JadwalSholatController> {
  final PageIndexController pageController = Get.find();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime dateNow = DateTime(now.year, now.month, now.day - 3);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('JadwalSholatView'),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            DigitalClock(
              areaDecoration: const BoxDecoration(color: Colors.transparent),
              hourMinuteDigitDecoration: const BoxDecoration(color: Colors.transparent),
              secondDigitDecoration: const BoxDecoration(color: Colors.transparent),
              hourMinuteDigitTextStyle: const TextStyle(fontSize: 40),
              secondDigitTextStyle: const TextStyle(fontSize: 40),
            ),
            Center(child: Text(controller.nameCity.value)),
            const SizedBox(height: 20.0),
            DatePicker(
              dateNow,
              width: 45,
              height: 80,
              controller: controller.datePicker,
              initialSelectedDate: DateTime.now(),
              selectionColor: appPurpleLight1,
              monthTextStyle: const TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
              ),
              dateTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
              dayTextStyle: const TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
              ),
              // selectedTextColor: Colors.white,
              onDateChange: (value) async {
                await controller.getJadwalSholat(controller.converDate(value.toIso8601String()));
              },
            ),
            const SizedBox(height: 20.0),
            //
            Obx(
              () {
                final box = GetStorage();
                if (controller.isLoading.isTrue) {
                  return Center(child: CircularProgressIndicator(color: Get.isDarkMode ? appwhite : appPurple));
                }
                if (controller.jadwalSholat.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(box.read('city') == null
                              ? 'Your location is not active'
                              : "Not found, check internet connection")),
                      ElevatedButton(
                        onPressed: () async {
                          if (box.read('city') == null) {
                            await controller.isLocationEnabled();
                            print('1');
                          } else {
                            // await controller.getJadwalSholat();
                            controller.jadwalsholat(controller.dateNow.value);
                            print('2');
                          }
                        },
                        child: const Text("Refresh"),
                      )
                    ],
                  );
                }
                modelJadwalSholat.JadwalSholat jadwal = controller.jadwalSholat.first;
                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      RsTimeline(
                        img: "assets/img/imsak.png",
                        label: 'Imsak',
                        value: jadwal.imsak.toString(),
                        isFirst: true,
                        isLast: false,
                      ),
                      RsTimeline(
                        img: "assets/img/subuh.png",
                        label: 'Subuh',
                        value: jadwal.subuh.toString(),
                        isFirst: false,
                        isLast: false,
                      ),
                      RsTimeline(
                        img: "assets/img/dhuha.png",
                        label: 'Dhuha',
                        value: jadwal.dhuha.toString(),
                        isFirst: false,
                        isLast: false,
                      ),
                      RsTimeline(
                        img: "assets/img/duhur.png",
                        label: 'Dzuhur',
                        value: jadwal.dzuhur.toString(),
                        isFirst: false,
                        isLast: false,
                      ),
                      RsTimeline(
                        img: "assets/img/ashar.png",
                        label: 'Ashar',
                        value: jadwal.ashar.toString(),
                        isFirst: false,
                        isLast: false,
                      ),
                      RsTimeline(
                        img: "assets/img/magrib.png",
                        label: 'Maghrib',
                        value: jadwal.maghrib.toString(),
                        isFirst: false,
                        isLast: false,
                      ),
                      RsTimeline(
                        img: "assets/img/isya.png",
                        label: 'Isya',
                        value: jadwal.isya.toString(),
                        isFirst: false,
                        isLast: true,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
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
