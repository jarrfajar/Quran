import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quran/app/data/constant/colors.dart';
import 'package:quran/app/data/db/bookmark.dart';
import 'package:quran/app/data/model/City.dart';
import 'package:quran/app/data/model/jadwalsholat.dart';
import 'package:quran/app/data/model/surah.dart';
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  RxBool isDark = false.obs;
  final surah = RxList<Surah>();
  final city = RxList<City>();
  final jadwalSholat = RxList<JadwalSholat>();

  DatabaseManager database = DatabaseManager.instance;

  // GET ALL SURAH
  Future<List<Surah>> getAllSurah() async {
    // Uri uri = Uri.parse('https://api.quran.gading.dev/surah');
    // var res = await http.get(uri);

    // List data = (json.decode(res.body) as Map<String, dynamic>)['data'];
    // if (data.isEmpty) {
    //   return [];
    // } else {
    //   return data.map((e) => Surah.fromJson(e)).toList();
    // }
    final String res = await rootBundle.loadString('assets/json/surah.json');
    final List<Surah> data = await (json.decode(res) as Map<String, dynamic>)['data']
        .map((json) => Surah.fromJson(json))
        .toList()
        .cast<Surah>();
    if (data.isEmpty) {
      return [];
    } else {
      surah.addAll(data);
      return surah;
    }
  }

  // CHANGE THEMA
  void changeThema() {
    Brightness brightness = SchedulerBinding.instance.window.platformBrightness;
    if (brightness == Brightness.dark) {
      // isDark.value = false;
      Get.snackbar('warning', 'Your phone is dark mode');
    }

    Get.changeTheme(Get.isDarkMode ? themaLight : themaDark);
    if (Get.isDarkMode) {
      isDark.value = false;
    } else {
      // isDark.value = false;
      isDark.toggle();
    }

    final box = GetStorage();
    Get.isDarkMode ? box.remove('themaDark') : box.write('themaDark', true);
  }

  // GET BOOKMARK
  Future<List<Map<String, dynamic>>> getBookmar() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataBookmar = await db.query('bookmark', where: 'last_read = 0', orderBy: 'id DESC');
    return dataBookmar;
  }

  // REMOVE BOOKMARK
  void removeBookmark(int id) async {
    Database db = await database.db;
    await db.delete('bookmark', where: "id = $id");

    update();
    Get.snackbar('Berhasil', 'Bookmark dihapus');
  }

  // LAST READ
  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> lastRead = await db.query('bookmark', where: 'last_read = 1');
    if (lastRead.isEmpty) {
      return null;
    } else {
      return lastRead.first;
    }
  }
}
