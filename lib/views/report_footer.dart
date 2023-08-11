import '../public.dart';

class ReportFooter extends StatelessWidget {
  const ReportFooter({Key? key, required this.type}) : super(key: key);

  final KHealthDataType type;

  Widget _getFooter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
      margin: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: (type == KHealthDataType.HEART_RATE ||
              type == KHealthDataType.BLOOD_OXYGEN)
          ? InkWell(
              onTap: () {
                Get.toNamed(Routes.USER_MANUA_RECORD);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "manual_record".tr,
                    style: Get.textTheme.displayLarge,
                  ),
                  LoadAssetsImage(
                    "icons/arrow_right_small",
                    width: 7,
                    height: 12,
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.getReportDesc(),
                  style: Get.textTheme.displayLarge,
                ),
                5.columnWidget,
                Text(
                  type.getReportDesc(isContent: true),
                  style: Get.textTheme.displaySmall,
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getFooter();
  }
}
