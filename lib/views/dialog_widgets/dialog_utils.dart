import 'package:beering/views/dialog_widgets/dialog_header.dart';
import 'package:beering/views/dialog_widgets/views/dialog_modify_goals.dart';
import 'package:beering/views/dialog_widgets/views/dialog_defaultpicker.dart';
import '../../public.dart';

class DialogUtils {
  DialogUtils._();

  static dialogModifyGoals() {
    return Get.bottomSheet(DialogModifyGoalsPage());
  }

  static Future dialogNDeviceTip() {
    return Get.bottomSheet(
      IntrinsicHeight(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: ColorUtils.fromHex("#FF232126"),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 6,
                margin: EdgeInsets.only(top: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "whynodevices".tr,
                  style: Get.textTheme.bodySmall,
                ),
                margin: EdgeInsets.only(top: 16.w),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "whynodevicestip".tr,
                  style: Get.textTheme.bodyMedium,
                ),
                margin: EdgeInsets.only(top: 12.w, bottom: 30.w),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  static Future defaultDialog({
    required String title,
    String? content,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    bool hiddenCancel = false,
    AlignmentGeometry? alignment,
  }) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: Colors.transparent,
        content: SingleChildScrollView(
          child: Container(
            width: 256.w,
            padding: const EdgeInsets.only(left: 12, right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: ColorUtils.fromHex("#FF232126"),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: 35.w, bottom: content != null ? 0 : 30.w),
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: Get.textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                Visibility(
                  visible: content != null,
                  child: Container(
                    margin: EdgeInsets.only(top: 10.w, bottom: 30.w),
                    alignment: alignment ?? Alignment.centerLeft,
                    child: Text(
                      content ?? "",
                      style: Get.textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !hiddenCancel,
                      child: Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: NextButton(
                                onPressed: () {
                                  Get.back();
                                  if (onCancel != null) {
                                    onCancel();
                                  }
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
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: NextButton(
                        onPressed: () {
                          Get.back();
                          if (onConfirm != null) {
                            onConfirm();
                          }
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
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Future dialogResetDevices({
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    return defaultDialog(
      title: "sure_reset".tr,
      onCancel: onCancel,
      onConfirm: onConfirm,
    );
  }

  static Future dialogDataPicker(
      {required String title,
      required List<String> datas,
      String? symbolText,
      int? initialItem,
      double? symbolRight}) {
    int selectIndex = initialItem ?? 0;

    return Get.bottomSheet(
      Container(
        height: 210.w,
        color: ColorUtils.fromHex("#FF232126"),
        child: Column(
          children: [
            DialogDefaultHeader(
              title: title,
              onCancel: () {
                Get.back(result: null);
              },
              onConfirm: () {
                Get.back(result: selectIndex);
              },
            ),
            Expanded(
              child: KCupertinoPicker(
                backgroundColor: ColorUtils.fromHex("#FF232126"),
                itemExtent: 44.w,
                scrollController: FixedExtentScrollController(
                  initialItem: initialItem ?? 0,
                ),
                onSelectedItemChanged: (a) {
                  selectIndex = a;
                },
                selectionOverlay: KCupertinoPickerDefaultOverlay(
                  margin: EdgeInsets.only(left: 12.w, right: 12.w),
                  borderRadius: BorderRadius.circular(12),
                  color: ColorUtils.fromHex("#FF000000"),
                  symbolText: Text(
                    symbolText ?? "",
                    style: Get.textTheme.bodyLarge,
                  ),
                  symbolRight: symbolRight,
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

  static Future dialogInputNickname() {
    TextEditingController contenEC = TextEditingController();

    return Get.dialog(
      Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            height: 149.w,
            width: 256.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: ColorUtils.fromHex("#FF232126"),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16.w),
                  child: Text(
                    "setting_nickname".tr,
                    style: Get.textTheme.displayLarge,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12.w, left: 12.w, right: 12.w),
                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                  height: 44.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: ColorUtils.fromHex("#FF000000"),
                  ),
                  child: TextField(
                    style: Get.textTheme.displayLarge,
                    controller: contenEC,
                    decoration: InputDecoration(
                      hintStyle: Get.textTheme.bodyMedium,
                      hintText: "input_nickname".tr,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      counterStyle: Get.textTheme.displaySmall,
                    ),
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
                        height: 57.w,
                        textStyle: Get.textTheme.displayLarge,
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
                          final text = contenEC.text;
                          if (text.isEmpty) {
                            HWToast.showErrText(text: "input_nickname".tr);
                            return;
                          }

                          Get.back(result: text);
                        },
                        title: "confirm".tr,
                        height: 57.w,
                        activeColor: Colors.transparent,
                        textStyle: Get.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
