import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class DialogModifyGoalsController extends GetxController {
  //TODO: Implement HomeEditCardController

  late KHealthDataType type;

  DialogModifyGoalsController({required this.type, required int currentValue}) {
    onInit();
    onChanged(currentValue);
  }

  RxInt minValue = RxInt(0);

  RxInt maxValue = RxInt(100);

  RxInt currentValue = RxInt(50);

  RxString currentStr = "0".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    if (type == KHealthDataType.STEPS) {
      minValue = RxInt(100);
      maxValue = RxInt(20000);
    } else if (type == KHealthDataType.LiCheng) {
      minValue = RxInt(1);
      maxValue = RxInt(20);
    } else if (type == KHealthDataType.CALORIES_BURNED) {
      minValue = RxInt(10);
      maxValue = RxInt(1000);
    } else if (type == KHealthDataType.SLEEP) {
      minValue = RxInt(4);
      maxValue = RxInt(12);
    }
  }

  void onCancel() {
    Get.back();
  }

  void onOk() {
    Get.back<int>(result: currentValue.value);
  }

  void onChanged(int value) {
    if (value >= maxValue.value) {
      value = maxValue.value;
    } else if (value <= minValue.value) {
      value = minValue.value;
    }
    currentValue.value = value;
    currentStr.value = value.toString() + type.getSymbol();
  }
}
