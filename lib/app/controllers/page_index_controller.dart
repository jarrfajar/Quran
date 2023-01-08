import 'package:get/get.dart';
import 'package:quran/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt index = 0.obs;

  void changePage(int i) async {
    index.value = i;
    switch (i) {
      case 1:
        Get.offAllNamed(Routes.JADWAL_SHOLAT);
        print(index.value);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
        print(index.value);
    }
  }
}
