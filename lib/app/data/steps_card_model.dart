import 'package:beering/public.dart';

class StepsCardAssetsModel {
  final String bgIcon;
  final String cardIcon;

  final String type;

  final KReportType pageType;

  final String value;

  StepsCardAssetsModel(
      {required this.bgIcon,
      required this.cardIcon,
      required this.type,
      required this.pageType,
      required this.value});

  static StepsCardAssetsModel getCardModel({
    required String value,
    required KReportType pageType,
    required KHealthDataType dataType,
  }) {
    if (dataType == KHealthDataType.LiCheng) {
      return StepsCardAssetsModel(
          bgIcon: pageType == KReportType.day
              ? "bg/dayreport_bg_distance"
              : "bg/weekreport_bg_distance",
          cardIcon: "icons/mine_icon_distance",
          type: "all_lichen".tr,
          pageType: pageType,
          value: "$value km");
    }

    if (dataType == KHealthDataType.CALORIES_BURNED) {
      return StepsCardAssetsModel(
          bgIcon: pageType == KReportType.day
              ? "bg/dayreport_bg_carolies"
              : "bg/weekreport_bg_carolies",
          cardIcon: "icons/mine_icon_calories",
          type: "all_xiaohao".tr,
          pageType: pageType,
          value: "$value kcal");
    }

    return StepsCardAssetsModel(
      bgIcon: pageType == KReportType.day
          ? "bg/dayreport_bg_steps"
          : "bg/weekreport_bg_steps",
      cardIcon: "icons/mine_icon_steps",
      type: "all_stepsnum".tr,
      value: "$value steps",
      pageType: pageType,
    );
  }
}
