import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/widgets/simple_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:focusring/utils/console_logger.dart';
import 'package:focusring/views/dialog_widgets/dialog_header.dart';
import 'package:focusring/views/dialog_widgets/views/dialog_modify_goals.dart';
import 'package:focusring/views/dialog_widgets/views/dialog_defaultpicker.dart';
import '../../public.dart';

class DialogUtils {
  DialogUtils._();

  static dialogModifyGoals() {
    return Get.bottomSheet(DialogModifyGoalsPage());
  }

  static dialogResetDevices() {
    return Get.defaultDialog(
      title: "",
      titlePadding: EdgeInsets.zero,
      backgroundColor: ColorUtils.fromHex("#FF232126"),
      radius: 16,
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.w, bottom: 35.w),
            child: Text(
              "sure_reset".tr,
              style: Get.textTheme.displayLarge,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: NextButton(
                  onPressed: () {
                    Get.back();
                  },
                  title: "cancel".tr,
                  activeColor: Colors.transparent,
                  textStyle: Get.textTheme.titleMedium,
                ),
              ),
              Container(
                width: 1,
                height: 32.w,
                color: ColorUtils.fromHex("#FF707070"),
              ),
              Expanded(
                child: NextButton(
                  onPressed: () {
                    Get.back();
                  },
                  title: "confirm".tr,
                  activeColor: Colors.transparent,
                  textStyle: Get.textTheme.displayLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static dialogDataPicker({
    required String title,
    required List<String> datas,
    String? symbolText,
    VoidCallback? onConfirm,
    Function(int index)? onSelectedItemChanged,
    int? initialItem,
  }) {
    return Get.bottomSheet(
      Container(
        height: 210.w,
        color: ColorUtils.fromHex("#FF232126"),
        child: Column(
          children: [
            DialogDefaultHeader(
              title: title,
              onCancel: () {
                Get.back();
              },
              onConfirm: () {
                Get.back();
                onConfirm?.call();
              },
            ),
            Expanded(
              child: KCupertinoPicker(
                backgroundColor: ColorUtils.fromHex("#FF232126"),
                itemExtent: 44.w,
                scrollController: FixedExtentScrollController(
                  initialItem: initialItem ?? 0,
                ),
                onSelectedItemChanged: onSelectedItemChanged,
                selectionOverlay: KCupertinoPickerDefaultOverlay(
                  margin: EdgeInsets.only(left: 12.w, right: 12.w),
                  borderRadius: BorderRadius.circular(12),
                  color: ColorUtils.fromHex("#FF000000"),
                  symbolText: Text(
                    symbolText ?? "",
                    style: Get.textTheme.bodyLarge,
                  ),
                ),
                children: datas
                    .map((e) => Container(
                          alignment: Alignment.center,
                          child: Text(
                            e,
                            style: Get.textTheme.bodyLarge,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
