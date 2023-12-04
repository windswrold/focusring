import 'dart:async';
import 'dart:math';

import 'package:beering/app/data/health_data_model.dart';
import 'package:beering/app/data/steps_card_model.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/date_util.dart';
import 'package:beering/views/charts/home_card/model/home_card_x.dart';
import 'package:beering/views/tra_led_button.dart';
import 'package:decimal/decimal.dart';
import 'package:get/get.dart';

import '../../../../const/event_bus_class.dart';
import '../../../../theme/theme.dart';
import '../../../../views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';
import '../../../../views/target_completion_rate.dart';
import '../../../../views/today_overview.dart';
import '../../../data/health_data_utils.dart';
import '../../../data/user_info.dart';

class ReportInfoStepsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement ReportInfoStepsController

  static const String id_data_souce_update = "id_data_souce_update";

  late List<Tab> myTabbas = [];
  late TabController tabController;
  late Rx<KReportType> reportType = KReportType.day.obs;
  late KHealthDataType currentType;

  //总步数 总和
  late RxString allResult = "-".obs;

  late RxList<StepsCardAssetsModel> stepsCards = <StepsCardAssetsModel>[].obs;

  late RxString chartTipValue = "".obs;

  late RxList<List<KChartCellData>> chartLists = RxList();

  StreamSubscription? queryTimeSub;

  late Rx<List<RadioGaugeChartData>> heartGaugeDatas = Rx([]);

  //完成率
  late Rx<List<TargetWeekCompletionRateModel>> targetWeekData =
      Rx(KTheme.weekColors
          .map(
            (e) => TargetWeekCompletionRateModel(
                color: e, dayNum: "0", complationNum: 0),
          )
          .toList());

  //完成目标
  late RxDouble complationData = RxDouble(0);

  late Rx<List<TodayOverViewModel>> todaysModel = Rx([]);

  late Rx<Duration?> sleep_time = Rx(null);
  late Rx<DateTime?> sleep_start = Rx(null);
  late Rx<DateTime?> sleep_end = Rx(null);

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
    todaysModel.value = TodayOverViewModel.getViewModel(
            type: currentType, one: "-", two: "-", three: "-")
        .obs;
    heartGaugeDatas.value = RadioGaugeChartData.getDefaultHeartGaugeData();
    queryTimeSub = GlobalValues.globalEventBus
        .on<KReportQueryTimeUpdate>()
        .listen((event) {
      _queryDataSource();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    queryTimeSub?.cancel();
    super.onClose();
  }

  void onTapType(int type) {
    reportType.value = KReportType.values[type];
    Get.find<TraLedButtonController>().changeReportType(reportType.value);
    _queryDataSource();
  }

  void _queryDataSource() async {
    final currentTime = Get.find<TraLedButtonController>().currentTime;
    HealthDataUtils.queryHealthData(
      types: currentType,
      reportType: reportType.value,
      currentTime: currentTime,
      callBackData: (a, b) {
        chartLists.value = b ?? [];
        update([id_data_souce_update]);
        updateViewData(a, currentTime);
      },
    );
  }

  void onTrackballPositionChanging(int? index) async {
    if (index == null) {
      return;
    }

    String text = HealthDataUtils.getOnTrackballTitle(
      type: reportType.value,
      currentType: currentType,
      dataSource: chartLists,
      index: index,
    );
    chartTipValue.value = text;
  }

  //计算总数
  //计算完成率
  void updateViewData(List<dynamic> a, DateTime currentTime) {
    UserInfoModel? user = SPManager.getGlobalUser();
    int planNum = user?.getPlanNum(currentType) ?? 0;
    if (currentType == KHealthDataType.HEART_RATE) {
      List<HeartRateData> datas = a as List<HeartRateData>;
      //平均
      allResult.value =
          ListEx.averageNum(datas.map((e) => e.averageHeartRate).toList())
              .toStringAsFixed(2);
      String max =
          ListEx.maxVal(datas.map((e) => e.max ?? 0).toList()).toString();
      String min =
          ListEx.minVal(datas.map((e) => e.min ?? 0).toList()).toString();
      String err = "0";
      todaysModel.value = TodayOverViewModel.getViewModel(
          type: currentType, one: "-", two: max, three: min);

      if (reportType.value == KReportType.day) {
        HeartRateData? model = datas.tryFirst;
        if (model != null) {
          heartGaugeDatas.value = model.calPercent();
        }
      }
    } else if (currentType == KHealthDataType.BLOOD_OXYGEN) {
      List<BloodOxygenData> datas = a as List<BloodOxygenData>;
      //平均
      allResult.value =
          ListEx.averageNum(datas.map((e) => e.averageHeartRate).toList())
              .toStringAsFixed(2);
      String max =
          ListEx.maxVal(datas.map((e) => e.max ?? 0).toList()).toString();
      String min =
          ListEx.minVal(datas.map((e) => e.min ?? 0).toList()).toString();
      String err = "0";
      todaysModel.value = TodayOverViewModel.getViewModel(
          type: currentType, one: max, two: min, three: err);
    } else if (currentType == KHealthDataType.BODY_TEMPERATURE) {
      List<TempData> datas = a as List<TempData>;
      //平均
      allResult.value = ListEx.averageNum(datas.map((e) => e.average).toList())
          .toStringAsFixed(2);
      String max =
          ListEx.maxVal(datas.map((e) => double.parse(e.max ?? "0")).toList())
              .toString();
      String min =
          ListEx.minVal(datas.map((e) => double.parse(e.min ?? "0")).toList())
              .toString();
      String err = "0";
      todaysModel.value = TodayOverViewModel.getViewModel(
          type: currentType, one: max, two: min, three: err);
    } else if (currentType == KHealthDataType.STEPS ||
        currentType == KHealthDataType.CALORIES_BURNED ||
        currentType == KHealthDataType.LiCheng) {
      //总和
      List<StepData> datas = a as List<StepData>;
      String xiaohao = ListEx.sumVal(datas.map((e) => e.calorie).toList())
          .toStringAsFixed(2);
      String licheng = ListEx.sumVal(datas.map((e) => e.distance).toList())
          .toStringAsFixed(2);
      String setps =
          ListEx.sumVal(datas.map((e) => e.steps).toList()).toStringAsFixed(2);
      if (currentType == KHealthDataType.STEPS) {
        allResult.value = setps;
      } else if (currentType == KHealthDataType.CALORIES_BURNED) {
        allResult.value = xiaohao;
      } else {
        allResult.value = licheng;
      }

      List<StepsCardAssetsModel> newCards = [];
      KReportType pageType = reportType.value;
      if (pageType == KReportType.day) {
        Decimal allNum = Decimal.tryParse(allResult.value) ?? Decimal.zero;
        Decimal planDeci = Decimal.fromInt(planNum);

        //完成目标
        complationData.value =
            getPercent(current: allNum.toDouble(), all: planDeci.toDouble());

        if (currentType == KHealthDataType.STEPS) {
          newCards.add(StepsCardAssetsModel.getCardModel(
              value: xiaohao,
              pageType: pageType,
              dataType: KHealthDataType.CALORIES_BURNED));
          newCards.add(StepsCardAssetsModel.getCardModel(
              value: licheng,
              pageType: pageType,
              dataType: KHealthDataType.LiCheng));
        } else if (currentType == KHealthDataType.CALORIES_BURNED) {
          newCards.add(StepsCardAssetsModel.getCardModel(
              value: setps,
              pageType: pageType,
              dataType: KHealthDataType.STEPS));
          newCards.add(StepsCardAssetsModel.getCardModel(
              value: licheng,
              pageType: pageType,
              dataType: KHealthDataType.LiCheng));
        } else if (currentType == KHealthDataType.LiCheng) {
          newCards.add(StepsCardAssetsModel.getCardModel(
              value: xiaohao,
              pageType: pageType,
              dataType: KHealthDataType.CALORIES_BURNED));
          newCards.add(StepsCardAssetsModel.getCardModel(
              value: setps,
              pageType: pageType,
              dataType: KHealthDataType.STEPS));
        }
      } else {
        //计算完成
        newCards.add(StepsCardAssetsModel.getCardModel(
            value: setps, pageType: pageType, dataType: KHealthDataType.STEPS));
        newCards.add(StepsCardAssetsModel.getCardModel(
            value: xiaohao,
            pageType: pageType,
            dataType: KHealthDataType.CALORIES_BURNED));
        newCards.add(StepsCardAssetsModel.getCardModel(
            value: licheng,
            pageType: pageType,
            dataType: KHealthDataType.LiCheng));

        List<DateTime> weeksTimes =
            getQueryStrings(reportType: pageType, now: currentTime);
        final rates = TargetWeekCompletionRateModel.getWeekModel(
            weeksTimes: weeksTimes,
            a: a,
            dataType: currentType,
            backData: (a) {
              complationData.value = a;
            });
        targetWeekData.value = rates;
      }

      stepsCards.value = newCards;
    } else if (currentType == KHealthDataType.SLEEP) {
      List<SleepData> datas = a as List<SleepData>;

      if (reportType.value == KReportType.day) {
        SleepData? data = datas.tryFirst;
        Decimal allNum =
            Decimal.tryParse(data?.getSleepTime() ?? "0") ?? Decimal.zero;
        Decimal planDeci = Decimal.fromInt(planNum);
        String deep_sleep_time = calDateMs(data?.deep_sleep_time ?? 0) ?? "";
        String light_sleep_time = calDateMs(data?.light_sleep_time ?? 0) ?? "";
        String awake_time = calDateMs(data?.awake_time ?? 0) ?? "";

        sleep_time.value = data?.getSleepDuration() ?? Duration.zero;
        sleep_start.value = DateTime.fromMillisecondsSinceEpoch(
            (data?.start_Sleep ?? 0) * 1000);
        sleep_end.value =
            DateTime.fromMillisecondsSinceEpoch((data?.end_Sleep ?? 0) * 1000);
        //完成目标
        complationData.value =
            getPercent(current: allNum.toDouble(), all: planDeci.toDouble());
        todaysModel.value = TodayOverViewModel.getViewModel(
            type: currentType,
            reportType: reportType.value,
            one: deep_sleep_time,
            two: light_sleep_time,
            three: awake_time);
      } else {
        List<DateTime> weeksTimes =
            getQueryStrings(reportType: reportType.value, now: currentTime);

        double deep_sleep_time = ListEx.averageNum(
            datas.map((e) => e.deep_sleep_time ?? 0).toList());
        double light_sleep_time = ListEx.averageNum(
            datas.map((e) => e.light_sleep_time ?? 0).toList());
        double awake_time =
            ListEx.averageNum(datas.map((e) => e.awake_time ?? 0).toList());
        String deep_sleep_timeStr = calDateMs(deep_sleep_time);
        String light_sleep_timeStr = calDateMs(light_sleep_time);
        String awake_timeStr = calDateMs(awake_time);

        todaysModel.value = TodayOverViewModel.getViewModel(
            type: currentType,
            reportType: reportType.value,
            one: deep_sleep_timeStr,
            two: light_sleep_timeStr,
            three: awake_timeStr);

        final rates = TargetWeekCompletionRateModel.getWeekModel(
            weeksTimes: weeksTimes,
            a: a,
            dataType: currentType,
            backData: (a) {
              complationData.value = a;
            });
        targetWeekData.value = rates;
      }
    }
  }
}
