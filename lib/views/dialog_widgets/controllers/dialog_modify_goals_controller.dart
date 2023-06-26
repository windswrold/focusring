import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class DialogModifyGoalsController extends GetxController {
  //TODO: Implement HomeEditCardController

  late KHealthDataType type;

  DialogModifyGoalsController(
      {required this.type, required double currentValue}) {
    onInit();
    onChanged(currentValue);
  }

  RxNum minValue = RxNum(0);

  RxNum maxValue = RxNum(100);

  RxNum currentValue = RxNum(50);

  RxString currentStr = "0.0".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    if (type == KHealthDataType.STEPS) {
      minValue = RxNum(100);
      maxValue = RxNum(20000);
    } else if (type == KHealthDataType.DISTANCE) {
      minValue = RxNum(1.0);
      maxValue = RxNum(20.00);
    } else if (type == KHealthDataType.CALORIES_BURNED) {
      minValue = RxNum(10);
      maxValue = RxNum(1000);
    } else if (type == KHealthDataType.SLEEP) {
      minValue = RxNum(4.0);
      maxValue = RxNum(12.0);
    }
  }

  void onCancel() {
    Get.back();
  }

  void onOk() {
    Get.back(result: currentValue.value);
  }

  void onChanged(double value) {
    if (value >= maxValue.value) {
      value = maxValue.value.toDouble();
    } else if (value <= minValue.value) {
      value = minValue.value.toDouble();
    }
    currentValue.value = value;
    currentStr.value = value.toStringAsFixed(2) + type.getSymbol();
  }
}
