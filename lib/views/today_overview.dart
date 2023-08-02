import '../public.dart';

class TodayOverViewModel {
  final String title;

  final String content;

  TodayOverViewModel({required this.title, required this.content});
}

class TodayOverView extends StatelessWidget {
  const TodayOverView({Key? key, required this.datas, required this.type})
      : super(key: key);

  final List<TodayOverViewModel> datas;

  final KReportType type;

  Widget _buildItem(String a, String b) {
    return Container(
      padding: EdgeInsets.only(top: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            a,
            style: Get.textTheme.displayLarge,
          ),
          10.rowWidget,
          Text(
            b,
            style: Get.textTheme.displayLarge,
          ),
        ],
      ),
    );
  }

  Widget _getTodayOverview() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              LoadAssetsImage(
                "icons/report_overview",
                width: 30,
                height: 30,
              ),
              10.rowWidget,
              Text(
                type.getOverviewTitle(),
                style: Get.textTheme.displayLarge,
              ),
            ],
          ),
          Column(
            children: datas.map((e) => _buildItem(e.title, e.content)).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getTodayOverview();
  }
}
