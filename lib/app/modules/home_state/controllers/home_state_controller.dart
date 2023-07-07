import 'package:focusring/app/routes/app_pages.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';
import 'package:get/get.dart';

class HomeStateController extends GetxController {
  //TODO: Implement HomeStateController

  RxList<RadioGaugeChartData> datas = <RadioGaugeChartData>[].obs;

  String mileageDefault = "5.00";
  String pedometerDefault = "8000";
  String exerciseDefault = "400";

  @override
  void onInit() {
    super.onInit();

    RadioGaugeChartData a =
        RadioGaugeChartData(percent: 50, color: const Color(0xFF00CEFF));
    RadioGaugeChartData b =
        RadioGaugeChartData(percent: 90, color: const Color(0xFF34E050));
    RadioGaugeChartData c =
        RadioGaugeChartData(percent: 50, color: const Color(0xFFFF723E));
    datas.add(a);
    datas.add(b);
    datas.add(c);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void onTapEditCard() {
    Get.toNamed(Routes.HOME_EDIT_CARD);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapCardType(KHealthDataType type) {
    Get.toNamed(Routes.REPORT_INFO_STEPS, arguments: type);

    return;

    if (type == KHealthDataType.STEPS ||
        type == KHealthDataType.LiCheng ||
        type == KHealthDataType.CALORIES_BURNED ||
        type == KHealthDataType.STRESS) {
      Get.toNamed(Routes.REPORT_INFO_STEPS);
    } else if (type == KHealthDataType.SLEEP) {
      Get.toNamed(Routes.REPORT_INFO_SLEEP);
    } else if (type == KHealthDataType.HEART_RATE) {
      Get.toNamed(Routes.REPORT_INFO_HEARTRATE);
    } else if (type == KHealthDataType.BLOOD_OXYGEN ||
        type == KHealthDataType.BODY_TEMPERATURE) {
      Get.toNamed(Routes.REPORT_INFO_BLOODOXYGEN);
    } else if (type == KHealthDataType.EMOTION) {
    } else if (type == KHealthDataType.FEMALE_HEALTH) {}
  }
}
