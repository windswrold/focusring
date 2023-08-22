import 'package:beering/extensions/StringEx.dart';
import 'package:beering/net/app_api.dart';
import 'package:beering/public.dart';
import 'package:get/get.dart';

class SettingFeedbackController extends GetxController {
  //TODO: Implement SettingFeedbackController

  RxList<String> datas = <String>[].obs;
  RxString chooseStr = "".obs;
  TextEditingController remarEC = TextEditingController();
  TextEditingController phoneEC = TextEditingController();

  RxBool isUpload = false.obs;

  @override
  void onInit() {
    super.onInit();

    datas = [
      "defaultfeedback_01",
      "defaultfeedback_02",
      "defaultfeedback_03",
      "defaultfeedback_04",
      "defaultfeedback_05",
      "defaultfeedback_06",
      "defaultfeedback_07",
      "defaultfeedback_08"
    ].obs;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapList(String element) {
    chooseStr.value = element;
  }

  void switchState() {
    isUpload.value = !isUpload.value;
  }

  void startReport() {
    final content = remarEC.text;
    final phone = phoneEC.text;
    if (content.isEmpty) {
      HWToast.showErrText(text: "input_feedback".tr);
      return;
    }
    if (phone.isNotEmpty) {
      bool state = phone.isValidPhoneNumber();
      if (state == false) {
        HWToast.showErrText(text: "input_feedback_phone".tr);
        return;
      }
    }
    HWToast.showLoading();
    AppApi.feedbackStream(
            content: content, phoneNumber: phone, questionType: chooseStr.value)
        .onSuccess((value) {
      HWToast.showSucText(text: "input_feedback_succ".tr);
      Get.backDelay();
    }).onError((r) {
      HWToast.showErrText(text: r.error ?? "");
    });
  }
}
