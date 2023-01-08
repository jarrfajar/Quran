import 'dart:convert';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran/app/data/model/City.dart';
import 'package:quran/app/data/model/jadwalsholat.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class JadwalSholatController extends GetxController {
  RxBool isLoading = false.obs;
  final DatePickerController datePicker = DatePickerController();

  final city = RxList<City>();
  final jadwalSholat = RxList<JadwalSholat>();
  RxString dateNow = ''.obs;
  RxString nameCity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage();
    nameCity.value = box.read('city') ?? 'Tidak ada kota';
    try {
      dateNow.value = converDate(DateTime.now().toIso8601String());
      getJadwalSholat(dateNow.value);
    } catch (e) {
      print(['errorr', e]);
    }
  }

  // TEST BY HARI onchage
  Future<List<JadwalSholat>> getJadwalSholat(String date) async {
    final box = GetStorage();
    var id = box.read('idCity');

    try {
      isLoading.value = true;
      Uri uri = Uri.parse('https://api.myquran.com/v1/sholat/jadwal/$id/$date');
      var res = await http.get(uri);

      Map<String, dynamic> data = (json.decode(res.body) as Map<String, dynamic>)['data']['jadwal'];
      JadwalSholat jadwal = JadwalSholat.fromJson(data);
      if (data.isEmpty) {
        return [];
      } else {
        jadwalSholat.clear();
        print('qwertyuop');
        jadwalSholat.add(jadwal);
        return jadwalSholat;
      }
    } catch (e) {
      print(['error', e]);
      Get.snackbar('Warning', e.toString());
    } finally {
      isLoading.value = false;
    }
    return [];
  }

// CEK GPS IS ACTIVE
  Future<void> isLocationEnabled() async {
    try {
      isLoading.value = true;
      final box = GetStorage();
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (isLocationEnabled) {
        Map<String, dynamic> response = await determinePosition();
        if (response['error'] != true) {
          Position position = response['position'];
          List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
          box.write('city', placemarks.first.subAdministrativeArea?.toLowerCase());
          // print(placemarks.first.subAdministrativeArea);
        } else {
          Get.snackbar('Warning', response['message']);
        }
      } else {
        Get.snackbar('Warning', 'Your location is not active');
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
  }

  // JADWAL SHOLAT
  void jadwalsholat(String date) async {
    final box = GetStorage();
    await isLocationEnabled();
    try {
      isLoading.value = true;
      if (box.read('city') == null) {
        // List<City> data = await getCity();
        // await isLocationEnabled();

        // String readCity = box.read('city');
        // var result = data.where((e) => e.lokasi!.toLowerCase().contains(readCity)).toList();
        print('citynulll');
      } else {
        // GET CITY
        await getCity();
        // GET JADWAL SHOLAT
        // await getJadwalSholat(converDate(DateTime.now().toIso8601String()));
        await getJadwalSholat(date);
        String readCity = box.read('city');
        var result = city.where((e) => e.lokasi!.toLowerCase().contains(readCity)).toList();
        if (result.isNotEmpty) {
          box.write('idCity', result.first.id);
        } else {
          Get.snackbar('Warning', 'Kota anda tidak ditemukan di jadwal sholat');
        }
        print(['result', result.length]);
        print(['city', city.length]);
        print('read');
        print(readCity);
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
  }

  // CONVERT DATE
  String converDate(String date) {
    //  2023-01-07T11:35:03.411598
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('yyyy/MM/dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  // GET CITY
  Future<List<City>> getCity() async {
    // city.clear();
    try {
      isLoading.value = true;
      Uri uri = Uri.parse('https://api.myquran.com/v1/sholat/kota/semua');
      var res = await http.get(uri);

      final List<City> data = (json.decode(res.body) as List).map((data) => City.fromJson(data)).toList().cast<City>();
      if (res.statusCode == 200) {
        if (data.isEmpty) {
          return [];
        } else {
          city.addAll(data);
          print(['kota ', city.length]);
          return city;
        }
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  // Get LATITUDE AND LONGTITUDE
  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      var data = {
        "message": 'Location services are disabled',
        "error": true,
      };
      return data;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        var data = {
          "message": 'Location permissions are denied',
          "error": true,
        };
        return data;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      var data = {
        "message": 'Location permissions are permanently denied',
        "error": true,
      };
      return data;
    }
    Position position = await Geolocator.getCurrentPosition();
    var data = {
      "position": position,
      "message": 'berhasil',
      "error": false,
    };
    return data;
  }
}
