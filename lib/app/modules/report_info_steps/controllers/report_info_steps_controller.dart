import 'dart:async';
import 'dart:math';

import 'package:focusring/app/data/steps_card_model.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/tra_led_button.dart';
import 'package:get/get.dart';

class ReportInfoStepsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement ReportInfoStepsController

  static const String id_data_souce_update = "id_data_souce_update";

  late List<Tab> myTabbas = [];
  late TabController tabController;
  late Rx<KReportType> reportType = KReportType.day.obs;
  late KHealthDataType currentType;

  late RxString allResult = "-".obs;

  late StreamSubscription dateSc;

  late RxList<StepsCardModel> stepsCards = <StepsCardModel>[].obs;

  late RxString chartTipValue = "".obs;

  late RxList<List<KChartCellData>> dataSource = [<KChartCellData>[]].obs;

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
    configCardData();
    _queryDataSource();
  }

  @override
  void onReady() {
    super.onReady();
    final a = Get.find<TraLedButtonController>();
    dateSc = a.displayTimeStream.listen((event) {
      vmPrint("displayTimeStream $event");
    });
  }

  @override
  void onClose() {
    dateSc.cancel();
    super.onClose();
  }

  void onTapType(int type) {
    reportType.value = KReportType.values[type];

    // allResult.value = Random.secure().nextInt(10000).toString();

    configCardData();
    _queryDataSource();
  }

  void configCardData() {
    List<StepsCardModel> datas = [];
    if (reportType.value == KReportType.day) {
      if (currentType == KHealthDataType.STEPS) {
        datas.add(
          StepsCardModel(
              bgIcon: "bg/dayreport_bg_carolies",
              cardIcon: "icons/mine_icon_calories",
              type: "all_xiaohao".tr,
              pageType: reportType.value,
              value: "0 kcal"),
        );
        datas.add(
          StepsCardModel(
              bgIcon: "bg/dayreport_bg_distance",
              cardIcon: "icons/mine_icon_distance",
              type: "all_lichen".tr,
              pageType: reportType.value,
              value: "0 kcal"),
        );
      } else if (currentType == KHealthDataType.CALORIES_BURNED) {
        datas.add(
          StepsCardModel(
              bgIcon: "bg/dayreport_bg_steps",
              cardIcon: "icons/mine_icon_steps",
              type: "all_stepsnum".tr,
              pageType: reportType.value,
              value: "0 kcal"),
        );
        datas.add(
          StepsCardModel(
              bgIcon: "bg/dayreport_bg_distance",
              cardIcon: "icons/mine_icon_distance",
              type: "all_lichen".tr,
              pageType: reportType.value,
              value: "0 kcal"),
        );
      } else if (currentType == KHealthDataType.LiCheng) {
        datas.add(
          StepsCardModel(
              bgIcon: "bg/dayreport_bg_carolies",
              cardIcon: "icons/mine_icon_calories",
              type: "all_stepsnum".tr,
              pageType: reportType.value,
              value: "0 kcal"),
        );
        datas.add(
          StepsCardModel(
              bgIcon: "bg/dayreport_bg_steps",
              cardIcon: "icons/mine_icon_steps",
              type: "all_stepsnum".tr,
              pageType: reportType.value,
              value: "0 kcal"),
        );
      }
    } else {
      datas.add(
        StepsCardModel(
          bgIcon: "bg/weekreport_bg_steps",
          cardIcon: "icons/mine_icon_steps",
          type: "average_stepsnum".tr,
          value: "0 kcal",
          pageType: reportType.value,
        ),
      );
      datas.add(
        StepsCardModel(
            bgIcon: "bg/weekreport_bg_carolies",
            cardIcon: "icons/mine_icon_calories",
            type: "all_xiaohao".tr,
            pageType: reportType.value,
            value: "0 kcal"),
      );
      datas.add(
        StepsCardModel(
            bgIcon: "bg/weekreport_bg_distance",
            cardIcon: "icons/mine_icon_distance",
            type: "all_lichen".tr,
            pageType: reportType.value,
            value: "0 kcal"),
      );
    }

    stepsCards.value = datas;
  }

  void _queryDataSource() {
    if (currentType == KHealthDataType.SLEEP) {
      dataSource.value = [
        List.generate(
          30,
          (index) => KChartCellData(
            x: index.toString(),
            y: 0,
            color: KSleepStatus.deepSleep.getStatusColor(),
          ),
        ),
        List.generate(
          30,
          (index) => KChartCellData(
            x: index.toString(),
            y: 0,
            color: KSleepStatus.lightSleep.getStatusColor(),
          ),
        ),
        List.generate(
          30,
          (index) => KChartCellData(
            x: index.toString(),
            y: 0,
            color: KSleepStatus.awake.getStatusColor(),
          ),
        )
      ];
    } else {
      var data = List.generate(
        30,
        (index) => KChartCellData(
          x: index.toString(),
          y: 0,
          color: currentType.getTypeMainColor(),
        ),
      );
      dataSource.value = [data];
    }

    update([id_data_souce_update]);
  }

  void onTrackballPositionChanging(int? index) {
    if (index == null) {
      return;
    }
    //11:30-11:59:765 steps

    String text = "";
    if (currentType == KHealthDataType.SLEEP) {
      // chartTipValue.value = "${item.x}:${item.y} steps";
      text = "-";
    } else {
      final item = dataSource.first[index];
      text = "- ${currentType.getSymbol()}";
    }
    chartTipValue.value = text;
    Future.delayed(const Duration(seconds: 3)).then((value) => {
          chartTipValue.value = "",
        });
  }
}
