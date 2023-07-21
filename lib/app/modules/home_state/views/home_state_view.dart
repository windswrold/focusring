import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:focusring/app/modules/home_devices/views/home_devices_view.dart';
import 'package:focusring/app/modules/edit_card/views/home_edit_card_view.dart';
import 'package:focusring/app/routes/app_pages.dart';
import 'package:focusring/const/constant.dart';
import 'package:focusring/public.dart';
import 'package:focusring/views/charts/home_card/model/home_card_type.dart';
import 'package:focusring/views/charts/home_card/views/home_card_item.dart';
import 'package:focusring/views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
            Obx(
              () => Column(
                  children:
                      controller.dataTypes.map((e) => _buildCard(e)).toList()),
            ),
            NextButton(
              onPressed: () {
                controller.onTapEditCard();
              },
              margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.w),
              title: 'edit_card'.tr,
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildHeader() {
    return Container(
        margin: EdgeInsets.only(left: 16.w, right: 0.w),
        // color: Colors.red,
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
            Obx(
              () => Expanded(
                child: SfCircularChart(
                  key: GlobalKey(),
                  series: [
                    RadialBarSeries<RadioGaugeChartData, String>(
                        cornerStyle: CornerStyle.bothCurve,
                        gap: '10%',
                        radius: '90%',
                        dataSource: controller.gaugeDatas..reversed.toList(),
                        xValueMapper: (RadioGaugeChartData data, _) =>
                            data.name ?? "",
                        yValueMapper: (RadioGaugeChartData data, _) =>
                            data.percent,
                        trackOpacity: 0.38,
                        trackColor: Colors.white38,
                        pointColorMapper: (RadioGaugeChartData data, _) =>
                            data.color,
                        pointRadiusMapper: (RadioGaugeChartData data, _) =>
                            "100%",
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: false))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildCard(KHomeCardModel a) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      child: InkWell(
        onTap: () {
          controller.onTapCardType(a);
        },
        child: HomeCardView(model: a),
      ),
    );
  }
}
