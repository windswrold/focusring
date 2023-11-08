import 'dart:async';
import 'dart:math';

import 'package:beering/utils/date_util.dart';

import '../const/event_bus_class.dart';
import '../public.dart';

class TraLedButtonController extends GetxController {
  Rx<String> disPlayTime = "".obs;
  DateTime currentTime = DateTime.now();
  KReportType? _type;

  @override
  void onInit() {
    super.onInit();
    changeReportType(KReportType.day);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeReportType(KReportType type) {
    _type = type;
    _setDisplayValue();
  }

  void left() {
    if (_type == KReportType.day) {
      currentTime = currentTime.subtract(const Duration(days: 1));
    } else if (_type == KReportType.week) {
      currentTime = currentTime.subtract(const Duration(days: 7));
    } else {
      currentTime = currentTime.previousMonth();
    }
    _setDisplayValue();
  }

  void right() {
    DateTime nowCureent;
    // DateTime newTime = nowCureent;
    if (_type == KReportType.day) {
      nowCureent = currentTime.add(const Duration(days: 1));
    } else if (_type == KReportType.week) {
      int offset = DateTime.now().difference(currentTime).inDays;
      offset = min(7, offset);
      offset = max(0, offset);
      nowCureent = currentTime.add(Duration(days: offset));
    } else {
      nowCureent = currentTime.nextMonth();
    }
    if (nowCureent.compareTo(DateTime.now()) >= 0) {
      return;
    }
    currentTime = nowCureent;
    _setDisplayValue();
  }

  void _setDisplayValue() {
    if (_type == KReportType.day) {
      disPlayTime.value =
          DateUtil.formatDate(currentTime, format: "yyyy/MM/dd");
    } else if (_type == KReportType.week) {
      disPlayTime.value =
          "${DateUtil.formatDate(currentTime.subtract(const Duration(days: 7)), format: "yyyy/MM/dd")}-${DateUtil.formatDate(currentTime, format: "yyyy/MM/dd")}";
    } else {
      disPlayTime.value = DateUtil.formatDate(currentTime, format: "yyyy/MM");
    }
    GlobalValues.globalEventBus.fire(KReportQueryTimeUpdate(currentTime));
  }
}

class TraLedButtonView extends StatelessWidget {
  const TraLedButtonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 61.w, right: 61.w, top: 12.w),
        child: GetBuilder<TraLedButtonController>(
            init: TraLedButtonController(),
            builder: (controller) {
              return Row(
                children: [
                  NextButton(
                    onPressed: () {
                      controller.left();
                    },
                    width: 29,
                    height: 29,
                    bgImg: assetsImages + "icons/report_arrow_left@3x.png",
                    title: "",
                  ),
                  Expanded(
                    child: Obx(
                      () => Text(
                        controller.disPlayTime.value,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  NextButton(
                    onPressed: () {
                      controller.right();
                    },
                    width: 29,
                    height: 29,
                    bgImg: assetsImages + "icons/report_arrow_right@3x.png",
                    title: "",
                  ),
                ],
              );
            }));
  }
}
