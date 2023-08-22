import 'package:beering/app/data/common_faq.dart';
import 'package:beering/app/routes/app_pages.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/utils/custom_toast.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class FaqViewController extends GetxController {
  //TODO: Implement FaqViewController

  RxList<KCommonFaqsModel> datas = <KCommonFaqsModel>[].obs;

  RefreshController refreshController = RefreshController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    _initData();
  }

  void onRefresh() {
    _initData();
    Future.delayed(Duration(seconds: 3)).then((value) => {
          refreshController.refreshCompleted(),
        });
  }

  void _initData() {
    AppApi.commonFaq().onSuccess((value) {
      datas.value = value;
    }).onError((r) {
      HWToast.showSucText(text: r.error ?? "");
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapList(int index) {
    var item = datas[index];
    HWToast.showLoading();

    AppApi.commonFaqDetail(model: item).onSuccess((value) {
      HWToast.hiddenAllToast();
      Get.toNamed(Routes.COMMON_HTML_VIEW, arguments: value.responseBody);
    }).onError((r) {
      HWToast.showSucText(text: r.error ?? "");
    });
  }
}
