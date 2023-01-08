import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran/app/data/model/surah.dart';
import 'package:http/http.dart' as http;

class SearchController extends GetxController {
  final surah = RxList<Surah>();
  final search = RxList<Surah>();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // getAllSurah();
    readJson();
    search.value = surah;
  }

  @override
  void onClose() {
    super.onClose();
  }

  // SEARCH
  void searchSurah(String value) {
    List<Surah> result = [];
    if (value.isEmpty) {
      result = surah;
    } else {
      result = surah.where((e) => e.name!.transliteration!.id!.toLowerCase().contains(value.toString())).toList();
      isLoading.value = true;
      Timer(const Duration(seconds: 1), () {
        isLoading.value = false;
        search.value = result;
      });
    }
  }

  // GET ALL SURAH
  Future<List<Surah>> getAllSurah() async {
    try {
      isLoading.value = true;
      Uri uri = Uri.parse('https://api.quran.gading.dev/surah');
      var res = await http.get(uri);

      // List data = (json.decode(res.body) as Map<String, dynamic>)['data'];
      final List<Surah> data = (json.decode(res.body) as Map<String, dynamic>)['data']
          .map((json) => Surah.fromJson(json))
          .toList()
          .cast<Surah>();
      if (res.statusCode == 200) {
        if (data.isEmpty) {
          return [];
        } else {
          surah.addAll(data);
          return surah;
        }
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  //
  Future<List<Surah>> readJson() async {
    try {
      isLoading.value = true;

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
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
    return [];
  }
}
