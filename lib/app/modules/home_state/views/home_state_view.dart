import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:focusring/app/modules/home_devices/views/home_devices_view.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/charts/radio_gauge_chart/views/radio_gauge_chart_view.dart';

import 'package:get/get.dart';

import '../controllers/home_state_controller.dart';

class HomeStateView extends GetView<HomeStateController> {
  const HomeStateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "home_status".tr,
      centerTitle: false,
      hiddenLeading: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    Widget _buildHeaderItem(
        {required String title,
        required String icon,
        required String value,
        required String valueColor,
        required String maxValue}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title, style: Get.textTheme.displayMedium),
          Container(
            margin: EdgeInsets.only(bottom: 11.42.w, top: 11.42.w),
            child: Row(
              children: [
                LoadAssetsImage(
                  icon,
                  width: 20,
                  height: 21,
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    value,
                    style: Get.textTheme.displayMedium?.copyWith(
                      color: ColorUtils.fromHex(valueColor),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text("/$maxValue", style: Get.textTheme.displaySmall),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Container(
        margin: EdgeInsets.only(left: 16.w, right: 16.w),
        height: 220.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.size.width / 2 - 40.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildHeaderItem(
                      title: "mileage".tr,
                      icon: "icons/status_target_distance",
                      value: "11",
                      valueColor: "#FF00CEFF",
                      maxValue: "${controller.mileageDefault}km"),
                  _buildHeaderItem(
                      title: "pedometer".tr,
                      icon: "icons/status_target_steps",
                      value: "111",
                      valueColor: "#FF34E050",
                      maxValue: "${controller.pedometerDefault}steps"),
                  _buildHeaderItem(
                      title: "exercise".tr,
                      icon: "icons/status_target_calorie",
                      value: "500",
                      valueColor: "#FFFF723E",
                      maxValue: "${controller.exerciseDefault}kcal"),
                ],
              ),
            ),
            Expanded(
              child: GetBuilder(
                init: controller,
                builder: ((_) => RadioGaugeChartView(
                      datas: controller.datas,
                    )),
              ),
            ),
          ],
        ));
  }
}
