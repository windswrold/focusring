import 'package:get/get.dart';
import 'package:focusring/model/wallet_objects.dart';
import 'package:focusring/pages/import/views/import_b.dart';
import 'package:focusring/router/router.dart';

class KCurrentWalletController extends GetxController {
  KCurrentWalletController();

  Rx<KWalletObjects>? wallet;

  RxInt count = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadWallet();
  }

  void loadWallet() async {
    KWalletObjects? model = await KWalletObjects.findSelect();

    wallet = model?.obs;
    print("loadWallet");
    update();
  }

  void addCount() async {
    count++;
  }

  void pushB() async {
    Get.to(() => PImportBWallet());
    // Routers.pushWidget(PImportBWallet());
  }
}
