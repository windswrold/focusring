import 'package:auto_size_text_plus/auto_size_text.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/app/modules/home_devices/views/home_devices_view.dart';
import 'package:beering/app/modules/edit_card/views/home_edit_card_view.dart';
import 'package:beering/app/routes/app_pages.dart';
import 'package:beering/const/constant.dart';
import 'package:beering/public.dart';
import 'package:beering/views/charts/home_card/model/home_card_type.dart';
import 'package:beering/views/charts/home_card/views/home_card_item.dart';
import 'package:beering/views/charts/radio_gauge_chart/model/radio_gauge_chart_model.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
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
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullUp: false,
        onRefresh: () {
          controller.onRefresh();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              GetBuilder<HomeStateController>(
                  id: "dataTypes",
                  builder: (a) {
                    return Column(
                        children: controller.dataTypes
                            .map((e) => _buildCard(e))
                            .toList());
                  }),
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
      ),
    );
  }

  Widget _buildHeaderItem({
    required Rx<RadioGaugeChartData> data,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text((data.value.title ?? "").tr, style: Get.textTheme.displayMedium),
        Container(
          margin: EdgeInsets.only(bottom: 11.42.w, top: 11.42.w),
          child: Row(
            children: [
              data.value.icon == null
                  ? Container()
                  : LoadAssetsImage(
                      data.value.icon!,
                      width: 20,
                      height: 21,
                    ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  (data.value.currentStr ?? "0"),
                  style: Get.textTheme.displayMedium?.copyWith(
                    color: data.value.color,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: AutoSizeText(
                    "/${data.value.allStr ?? 0}${data.value.symbol ?? ""}",
                    style: Get.textTheme.displaySmall,
                    minFontSize: 5,
                    maxLines: 1,
                  ),
                ),
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
            Obx(
              () => Container(
                width: Get.size.width / 2 - 20.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildHeaderItem(
                      data: controller.licheng,
                    ),
                    _buildHeaderItem(
                      data: controller.steps,
                    ),
                    _buildHeaderItem(
                      data: controller.calorie,
                    ),
                  ],
                ),
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
                      dataSource: [
                        controller.licheng.value,
                        controller.steps.value,
                        controller.calorie.value
                      ].reversed.toList(),
                      xValueMapper: (RadioGaugeChartData data, _) =>
                          data.title ?? "",
                      yValueMapper: (RadioGaugeChartData data, _) =>
                          data.calPercent(),
                      maximumValue: 1,
                      trackOpacity: 0.38,
                      trackColor: Colors.white38,
                      pointColorMapper: (RadioGaugeChartData data, _) =>
                          data.color,
                      pointRadiusMapper: (RadioGaugeChartData data, _) =>
                          "100%",
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false),
                    ),
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
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          controller.onTapCardType(a);
        },
        child: HomeCardView(model: a),
      ),
    );
  }
}
