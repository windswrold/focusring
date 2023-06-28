import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../public.dart';
import '../controllers/setting_feedback_controller.dart';

class SettingFeedbackView extends GetView<SettingFeedbackController> {
  const SettingFeedbackView({Key? key}) : super(key: key);

  Widget _getQuestionType() {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48.w,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: "feed_question".tr,
                style: Get.textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: " *",
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: ColorUtils.fromHex("#FFFF0000"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Wrap(
            runSpacing: 12.w,
            spacing: 10.w,
            children: [
              IntrinsicWidth(
                child: NextButton(
                  onPressed: () {},
                  title: "蓝牙连接",
                  borderRadius: 14,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                  activeColor: ColorUtils.fromHex("#FF000000"),
                  textStyle: Get.textTheme.displaySmall,
                ),
              ),
              IntrinsicWidth(
                child: NextButton(
                  onPressed: () {},
                  title: "蓝牙连接",
                  textStyle: Get.textTheme.displaySmall,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                  borderRadius: 14,
                  activeColor: ColorUtils.fromHex("#FF000000"),
                ),
              ),
              IntrinsicWidth(
                child: NextButton(
                  onPressed: () {},
                  title: "蓝牙连接",
                  textStyle: Get.textTheme.displaySmall,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                  borderRadius: 14,
                  activeColor: ColorUtils.fromHex("#FF000000"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getFeedInput() {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48.w,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: "feed_desc".tr,
                style: Get.textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: " *",
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: ColorUtils.fromHex("#FFFF0000"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ColorUtils.fromHex("#FF000000"),
            ),
            child: TextField(
              maxLines: 10,
              maxLength: 1000,
              style: Get.textTheme.labelSmall,
              decoration: InputDecoration(
                hintStyle: Get.textTheme.displayLarge,
                hintText: "feed_input".tr,
                filled: true,
                fillColor: ColorUtils.fromHex("#FF000000"),
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                counterStyle: Get.textTheme.displaySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFeedTel() {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48.w,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: "feed_tel".tr,
                style: Get.textTheme.bodySmall,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: TextField(
              maxLines: 1,
              style: Get.textTheme.labelSmall,
              decoration: InputDecoration(
                hintStyle: Get.textTheme.displayLarge,
                hintText: "feed_teldesc".tr,
                filled: true,
                fillColor: ColorUtils.fromHex("#FF000000"),
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                counterStyle: Get.textTheme.displaySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "Feedback".tr,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _getQuestionType(),
            _getFeedInput(),
            _getFeedTel(),
            Container(
              padding: EdgeInsets.only(right: 12.w),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    iconSize: 20,
                    icon: LoadAssetsImage(
                      "icons/state_true",
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "feed_upload".tr,
                      style: Get.textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
            NextButton(
              onPressed: () {},
              title: "submit".tr,
              margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.w),
              textStyle: Get.textTheme.displayLarge,
              height: 44.w,
              gradient: LinearGradient(colors: [
                ColorUtils.fromHex("#FF0E9FF5"),
                ColorUtils.fromHex("#FF02FFE2"),
              ]),
              borderRadius: 22,
            )
          ],
        ),
      ),
    );
  }
}
