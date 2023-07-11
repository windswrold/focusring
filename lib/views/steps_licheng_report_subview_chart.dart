import '../public.dart';

class StepsLiChengSubviewChart extends StatelessWidget {
  const StepsLiChengSubviewChart({Key? key, required this.pageType})
      : super(key: key);

  final int pageType;

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
          image: DecorationImage(
            image: AssetImage("$assetsImages$bgIcon@3x.png"),
          ),
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

  @override
  Widget build(BuildContext context) {
    List<Widget> datas = [];
    if (pageType == 0) {
      datas.add(
        _getCardItem(
            bgIcon: "bg/dayreport_bg_carolies",
            cardIcon: "icons/mine_icon_calories",
            type: "all_xiaohao".tr,
            pageType: pageType,
            value: "123 kcal"),
      );
      datas.add(
        _getCardItem(
            bgIcon: "bg/dayreport_bg_distance",
            cardIcon: "icons/mine_icon_distance",
            type: "all_lichen".tr,
            pageType: pageType,
            value: "123 kcal"),
      );
    } else {
      datas.add(
        _getCardItem(
          bgIcon: "bg/weekreport_bg_steps",
          cardIcon: "icons/mine_icon_steps",
          type: "average_stepsnum".tr,
          value: "123 kcal",
          pageType: pageType,
        ),
      );
      datas.add(
        _getCardItem(
            bgIcon: "bg/weekreport_bg_carolies",
            cardIcon: "icons/mine_icon_calories",
            type: "all_xiaohao".tr,
            pageType: pageType,
            value: "123 kcal"),
      );
      datas.add(
        _getCardItem(
            bgIcon: "bg/weekreport_bg_distance",
            cardIcon: "icons/mine_icon_distance",
            type: "all_lichen".tr,
            pageType: pageType,
            value: "123 kcal"),
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: datas,
      ),
    );
  }
}
