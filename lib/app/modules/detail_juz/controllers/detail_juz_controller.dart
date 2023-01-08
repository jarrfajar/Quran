import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:quran/app/data/db/bookmark.dart';
import 'package:quran/app/data/model/juz.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqflite.dart';

class DetailJuzController extends GetxController {
  final player = AudioPlayer();
  Verses? lastVerses;

  DatabaseManager database = DatabaseManager.instance;

  AutoScrollController scrollController = AutoScrollController();

  RxDouble fontTranslation = 16.0.obs;
  RxDouble fontArab = 26.0.obs;

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage();

    if (box.read('fontArab') != null) {
      print(box.read('fontArab'));
      fontArab.value = box.read('fontArab');
    }
    if (box.read('fontTranslation') != null) {
      fontTranslation.value = box.read('fontTranslation');
    }
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }

  // GET DETAIL JUZ
  Future<Juz> getDetailJuz(String id) async {
    Uri uri = Uri.parse('https://api.quran.gading.dev/juz/$id');
    var res = await http.get(uri);

    Map<String, dynamic> data = (json.decode(res.body) as Map<String, dynamic>)['data'];
    print(data);
    // var test = Juz.fromJson(data);
    // print(test.totalVerses);
    return Juz.fromJson(data);
  }

  // PLAY
  void playAudio(Verses? ayat) async {
    if (ayat?.audio?.primary != null) {
      try {
        lastVerses ??= ayat;
        lastVerses!.kondisiAudio = 'stop';
        lastVerses = ayat;
        update();
        //
        lastVerses!.kondisiAudio = 'stop';
        await player.stop();
        await player.setUrl(ayat!.audio!.primary!);

        ayat.kondisiAudio = 'playing';
        update();
        await player.play();

        ayat.kondisiAudio = 'stop';
        await player.stop();
        update();
      } on PlayerException catch (e) {
        print("Error code: ${e.code}");
        print("Error message: ${e.message}");
      } on PlayerInterruptedException catch (e) {
        print("Connection aborted: ${e.message}");
      } catch (e) {
        print('An error occured: $e');
      }

      // Catching errors during playback (e.g. lost network connection)
      player.playbackEventStream.listen(
        (event) {},
        onError: (Object e, StackTrace st) {
          if (e is PlayerException) {
            print('Error code: ${e.code}');
            print('Error message: ${e.message}');
          } else {
            print('An error occurred: $e');
          }
        },
      );
    } else {
      print('Error');
    }
  }

  // PAUSE
  void pauseAudio(Verses ayat) async {
    try {
      await player.pause();
      ayat.kondisiAudio = 'pause';
      update();
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
    } catch (e) {
      print('An error occured: $e');
    }
  }

  // RESUME
  void resumeAudio(Verses ayat) async {
    try {
      ayat.kondisiAudio = 'playing';
      update();

      await player.play();
      ayat.kondisiAudio = 'stop';
      update();
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
    } catch (e) {
      print('An error occured: $e');
    }
  }

  // STOP
  void stopAudio(Verses ayat) async {
    try {
      await player.stop();
      ayat.kondisiAudio = 'stop';
      update();
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
    } catch (e) {
      print('An error occured: $e');
    }
  }

  // BOOKMAR
  Future<void> bookmar(bool lastRead, Juz surah, Verses ayat, int indexAyat) async {
    Database db = await database.db;

    bool flagExist = false;

    if (lastRead == true) {
      await db.delete('bookmark', where: 'last_read = 1');
    } else {
      List checkData = await db.query('bookmark',
          columns: ["surah", "number_surah", "ayat", "juz", "via", "index_ayat", "last_read"],
          where:
              "surah = '${surah.juz.toString()}' and ayat = ${ayat.number!.inSurah} and juz = ${ayat.meta!.juz}  and via = 'juz' and index_ayat = $indexAyat and last_read = 0");
      if (checkData.isNotEmpty) {
        flagExist = true;
      }
    }
    if (flagExist == false) {
      await db.insert('bookmark', {
        // 'surah': surah.name!.transliteration!.id!.replaceAll("'", "+"),
        'surah': 'Juz ${surah.juz}',
        //  'number_surah': surah.number,
        'ayat': ayat.number!.inSurah,
        'juz': ayat.meta!.juz,
        'via': 'juz',
        'index_ayat': indexAyat,
        'last_read': lastRead == true ? 1 : 0,
      });

      Get.back();
      Get.snackbar('Berhasil', 'Bookmark berhasil');
    } else {
      Get.back();
      Get.snackbar('Gagal', 'Terjadi Kesalahan');
    }

    var data = await db.query('bookmark');
    print(data);
  }
}
