import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:focusring/theme/theme.dart';
import 'package:focusring/views/charts/home_card/model/home_card_x.dart';
import 'package:focusring/views/charts/progress_chart.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../public.dart';
import '../controllers/report_info_steps_controller.dart';

class ReportInfoStepsView extends GetView<ReportInfoStepsController> {
  const ReportInfoStepsView({Key? key}) : super(key: key);
  Widget _getAppBar() {
    return controller.currentType == KHealthDataType.CALORIES_BURNED
        ? Obx(() => AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 40.w,
              leading: KBasePageView.getBack(() {
                Get.back();
              }),
              centerTitle: true,
              title: Text(
                controller.reportType.value.getCaloriesTitle(),
                style: Get.textTheme.titleLarge,
                textAlign: TextAlign.left,
              ),
            ))
        : AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 40.w,
            leading: KBasePageView.getBack(() {
              Get.back();
            }),
            centerTitle: true,
            title: Text(
              controller.currentType.getDisplayName(isReport: true),
              style: Get.textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
          );
  }

  Widget _getTabbarTitle() {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(40),
      ),
      child: ButtonsTabBar(
        controller: controller.tabController,
        tabs: controller.myTabbas,
        buttonMargin: EdgeInsets.zero,
        unselectedLabelStyle: Get.theme.tabBarTheme.unselectedLabelStyle,
        labelStyle: Get.theme.tabBarTheme.labelStyle,
        splashColor: Colors.transparent,
        radius: 0,
        labelSpacing: 0,
        itemWidth: 85.w,
        height: 30.w,
        contentPadding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF212526"),
          borderRadius: BorderRadius.circular(40),
        ),
        unselectedDecoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(40),
        ),
        onTap: (a) {
          controller.onTapType(a);
        },
      ),
    );
  }

  Widget _getArrowTitle() {
    return Container(
      margin: EdgeInsets.only(left: 61.w, right: 61.w, top: 12.w),
      child: Row(
        children: [
          NextButton(
            onPressed: () {},
            width: 29,
            height: 29,
            bgImg: assetsImages + "icons/report_arrow_left@3x.png",
            title: "",
          ),
          Expanded(
            child: Text(
              "data",
              textAlign: TextAlign.center,
            ),
          ),
          NextButton(
            onPressed: () {},
            width: 29,
            height: 29,
            bgImg: assetsImages + "icons/report_arrow_right@3x.png",
            title: "",
          ),
        ],
      ),
    );
  }

  Widget _getBigTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10.w),
      child: Column(
        children: [
          Text(
            "89000",
            style: Get.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Text(
            controller.currentType.getDisplayName(isReportSmallTotal: true),
            style: Get.textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _getMubiao(int pageType) {
    var day =
        "${controller.currentType.getDisplayName(isMubiao: true)}: 8000${controller.currentType.getSymbol()}";
    var week = "average_completionrate".tr;
    var moneth = "average_completionrate".tr;

    Color? color = controller.currentType.getTypeMainColor();
    if (pageType == 0) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.w),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: Get.textTheme.displayLarge,
                ),
                Row(
                  children: [
                    ProgressChart(
                      progressValue: 57,
                      rangePointerColor: color,
                      textColor: color,
                    ),
                    17.rowWidget,
                    LoadAssetsImage(
                      "icons/arrow_right_small",
                      width: 7,
                      height: 12,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else if (pageType == 1) {
      Widget weeekItem(
          {required double progressValue,
          required Color textColor,
          required String dayNum}) {
        return Column(
          children: [
            ProgressChart(
                progressValue: progressValue,
                textColor: textColor,
                rangePointerColor: textColor),
            4.columnWidget,
            Text(
              dayNum,
              style: Get.textTheme.displaySmall,
            ),
          ],
        );
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.w),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  week,
                  style: Get.textTheme.displayLarge,
                ),
                Row(
                  children: [
                    Text(
                      "100%",
                      style: Get.textTheme.displayLarge,
                    ),
                    17.rowWidget,
                    LoadAssetsImage(
                      "icons/arrow_right_small",
                      width: 7,
                      height: 12,
                    ),
                  ],
                ),
              ],
            ),
            10.columnWidget,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: KTheme.weekColors
                  .map((e) =>
                      weeekItem(progressValue: 1, textColor: e, dayNum: "1"))
                  .toList(),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                moneth,
                style: Get.textTheme.displayLarge,
              ),
              Row(
                children: [
                  Text(
                    "100%",
                    style: Get.textTheme.displayLarge,
                  ),
                  17.rowWidget,
                  LoadAssetsImage(
                    "icons/arrow_right_small",
                    width: 7,
                    height: 12,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getLeiji(int pageType) {
    Widget _getCardItem({
      required String bgIcon,
      required String cardIcon,
      required String type,
      required String value,
      required int pageType,
    }) {
      if (pageType == 0) {
        return Container(
          width: 170.w,
          height: 70.w,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
          decoration: BoxDecoration(
            color: ColorUtils.fromHex("#FF000000"),
            // image: DecorationImage(
            //   image: AssetImage("$assetsImages$bgIcon@3x.png"),
            // ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LoadAssetsImage(
                cardIcon,
                width: 30,
                height: 30,
              ),
              11.rowWidget,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      type,
                      style: Get.textTheme.displayLarge,
                    ),
                    4.columnWidget,
                    Text(
                      value,
                      style: Get.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        width: 110.w,
        height: 140.w,
        padding: EdgeInsets.only(top: 20.w, left: 2, right: 2),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          image: DecorationImage(
            image: AssetImage("$assetsImages$bgIcon@3x.png"),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LoadAssetsImage(
              cardIcon,
              width: 26,
              height: 28,
            ),
            21.columnWidget,
            Text(
              type,
              style: Get.textTheme.displayLarge,
            ),
            4.columnWidget,
            Text(
              value,
              style: Get.textTheme.labelMedium,
            ),
          ],
        ),
      );
    }

    List<Widget> datas = [];

    if (pageType == 1 || pageType == 2) {
      datas.add(
        _getCardItem(
          bgIcon: "icons/mine_stepstarget_bg",
          cardIcon: "icons/mine_icon_steps",
          type: "average_stepsnum".tr,
          value: "123 kcal",
          pageType: pageType,
        ),
      );
    }
    datas.add(
      _getCardItem(
          bgIcon: "icons/mine_stepstarget_bg",
          cardIcon: "icons/mine_icon_calories",
          type: "all_xiaohao".tr,
          pageType: pageType,
          value: "123 kcal"),
    );
    datas.add(
      _getCardItem(
          bgIcon: "icons/mine_distancetarget_bg",
          cardIcon: "icons/mine_icon_distance",
          type: "all_lichen".tr,
          pageType: pageType,
          value: "123 kcal"),
    );

    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: datas,
      ),
    );
  }

  Widget _getDesc() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
      margin: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "steps_info_tip1".tr,
            style: Get.textTheme.displayLarge,
          ),
          5.columnWidget,
          Text(
            "steps_info_tip2".tr,
            style: Get.textTheme.displaySmall,
          ),
        ],
      ),
    );
  }

  Widget _getPageViewWidget(int pageType) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _buildChart(),
            _getMubiao(pageType),
            _getLeiji(pageType),
            _getDesc(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 283.w,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(
            // text: "111",
            // backgroundColor: ColorUtils.fromHex("#FF34E050"),
            ),
        primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0), // 设置主要网格线样式
          minorGridLines: MinorGridLines(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          minorTickLines: MinorTickLines(width: 0),
          axisLine: AxisLine(
            color: ColorUtils.fromHex("#FF2C2F2F"),
          ),
          labelStyle: Get.textTheme.displaySmall,
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(
              dashArray: [1, 2], color: ColorUtils.fromHex("#FF2C2F2F")),
          minorGridLines: MinorGridLines(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          minorTickLines: MinorTickLines(width: 0),
          axisLine: AxisLine(
            width: 0,
          ),
          labelStyle: Get.textTheme.displaySmall,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          tooltipPosition: TooltipPosition.auto,
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipAlignment: ChartAlignment.near,
          markerSettings: TrackballMarkerSettings(
            // markerVisibility: TrackballVisibilityMode.visible,
            width: 8,
            height: 8,
            color: Colors.blue, // 设置标记点的颜色
            borderWidth: 2,
            borderColor: Colors.white,
          ),
          lineColor: ColorUtils.fromHex("#FF34E050").withOpacity(0.5),
          lineType: TrackballLineType.horizontal,
          lineWidth: 11,
          shouldAlwaysShow: true,
          tooltipSettings: InteractiveTooltip(
              // borderColor: Colors.blue, // 设置浮动球的边框颜色
              // color: Colors.blue, // 设置浮动球的填充颜色
              // borderRadius: BorderRadius.circular(8), // 设置浮动球的圆角半径
              // elevation: 2,
              ),
        ),
        series: _getSteps(),
      ),
    );
  }

  List<ColumnSeries<HomeCardItemModel, String>> _getSteps() {
    return <ColumnSeries<HomeCardItemModel, String>>[
      ColumnSeries<HomeCardItemModel, String>(
        dataSource: List.generate(30,
            (index) => HomeCardItemModel(x: "15:$index", y: index.toDouble())),
        isTrackVisible: false,
        borderRadius: BorderRadius.circular(3),
        xValueMapper: (HomeCardItemModel sales, _) => sales.x,
        yValueMapper: (HomeCardItemModel sales, _) => sales.y,
        pointColorMapper: (datum, index) => datum.color,
        dataLabelSettings: const DataLabelSettings(
          isVisible: false,
        ),
        onPointTap: (pointInteractionDetails) {
          vmPrint(pointInteractionDetails.seriesIndex);
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.myTabbas.length,
      child: KBasePageView(
        hiddenAppBar: true,
        safeAreaTop: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: controller.currentType.getReportGradient(),
          ),
          child: Column(
            children: [
              _getAppBar(),
              _getTabbarTitle(),
              _getArrowTitle(),
              _getBigTitle(),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: [
                    _getPageViewWidget(0),
                    _getPageViewWidget(1),
                    _getPageViewWidget(2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
