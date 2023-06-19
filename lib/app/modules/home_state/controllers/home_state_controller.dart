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
        RadioGaugeChartData(percent: 30, color: const Color(0xFF34E050));
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

  @override
  void onClose() {
    super.onClose();
  }
}
