import 'dart:async';

import 'package:focusring/utils/date_util.dart';

import '../public.dart';

class TraLedButtonController extends GetxController {
  Rx<DateTime> disPlayTime = DateTime.now().obs;

  Stream<DateTime> get displayTimeStream =>
      _displayTimeStreamController.stream.asBroadcastStream();
  final _displayTimeStreamController = StreamController<DateTime>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void left() {
    final now = disPlayTime.value.subtract(const Duration(days: 1));
    disPlayTime.value = now;
    _displayTimeStreamController.add(now);
  }

  void right() {
    if (DateUtil.dayIsEqual(disPlayTime.value, DateTime.now())) {
      return;
    }

    final now = disPlayTime.value.add(const Duration(days: 1));
    disPlayTime.value = now;
    _displayTimeStreamController.add(now);
  }
}

class TraLedButton extends StatelessWidget {
  const TraLedButton({Key? key}) : super(key: key);

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
                        DateUtil.formatDate(
                          controller.disPlayTime.value,
                          format: "yyyy/MM/dd",
                        ),
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
