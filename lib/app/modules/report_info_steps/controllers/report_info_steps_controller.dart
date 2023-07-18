import 'package:focusring/public.dart';
import 'package:get/get.dart';

class ReportInfoStepsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement ReportInfoStepsController

  late List<Tab> myTabbas = [];
  late TabController tabController;
  late Rx<KReportType> reportType = KReportType.day.obs;

  late KHealthDataType currentType;

  @override
  void onInit() {
    super.onInit();

    currentType = Get.arguments;
    myTabbas = [
      Tab(
        text: ("Day".tr),
      ),
      Tab(
        text: ("Week".tr),
      ),
      Tab(
        text: ("Month".tr),
      ),
    ];
    tabController = TabController(vsync: this, length: myTabbas.length);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapType(int type) {
    reportType.value = KReportType.values[type];
  }
}
