import 'package:bot_toast/bot_toast.dart';
import '../public.dart';

class HWToast {
  static showSucText({
    required String text,
    Color? contentColor,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(22)),
    AlignmentGeometry? align,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
    Duration duration = const Duration(seconds: 3),
    Duration? animationDuration,
    Duration? animationReverseDuration,
  }) {
    HWToast.hiddenAllToast();
    BotToast.showCustomText(
      toastBuilder: ((cancelFunc) {
        return Container(
            padding: contentPadding,
            margin: EdgeInsets.only(left: 12.w, right: 12.w),
            decoration: BoxDecoration(
              color: contentColor ?? ColorUtils.fromHex("#FF202222"),
              borderRadius: borderRadius,
            ),
            child: Row(
              children: [
                LoadAssetsImage(
                  "icons/toast_suc",
                  width: 4,
                  height: 20,
                ),
                11.rowWidget,
                Expanded(
                  child: Text(
                    text,
                    style: Get.textTheme.displayLarge,
                  ),
                ),
              ],
            ));
      }),
      align: Alignment(0, 0.5),
      duration: duration,
      animationDuration: animationDuration,
      animationReverseDuration: animationReverseDuration,
      onlyOne: true,
      enableKeyboardSafeArea: true,
    );
  }

  static showErrText({
    required String text,
    Color? contentColor,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(22)),
    AlignmentGeometry? align,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
    Duration duration = const Duration(seconds: 3),
    Duration? animationDuration,
    Duration? animationReverseDuration,
  }) {
    HWToast.hiddenAllToast();
    BotToast.showCustomText(
      toastBuilder: ((cancelFunc) {
        return Container(
            padding: contentPadding,
            margin: EdgeInsets.only(left: 12.w, right: 12.w),
            decoration: BoxDecoration(
              color: contentColor ?? ColorUtils.fromHex("#FF202222"),
              borderRadius: borderRadius,
            ),
            child: Row(
              children: [
                LoadAssetsImage(
                  "icons/toast_arrow",
                  width: 4,
                  height: 20,
                ),
                11.rowWidget,
                Expanded(
                  child: Text(
                    text,
                    style: Get.textTheme.displayLarge,
                  ),
                ),
              ],
            ));
      }),
      align: Alignment(0, 0.5),
      duration: duration,
      animationDuration: animationDuration,
      animationReverseDuration: animationReverseDuration,
      onlyOne: true,
      enableKeyboardSafeArea: true,
    );
  }

  static showLoading({
    VoidCallback? onClose,
    bool clickClose = true,
  }) {
    HWToast.hiddenAllToast();
    BotToast.showLoading(
      enableKeyboardSafeArea: true,
      onClose: onClose,
      clickClose: clickClose,
      backgroundColor: Colors.transparent,
    ); //弹出一个文本框;
  }

  static hiddenAllToast() {
    BotToast.cleanAll();
  }
}
