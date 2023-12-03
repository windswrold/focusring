import '../public.dart';

class TodayOverViewModel {
  final String title;

  final String content;

  final Color? color;

  TodayOverViewModel({required this.title, required this.content, this.color});

  static List<TodayOverViewModel> getViewModel({
    required KHealthDataType type,
    required String one,
    required String two,
    required String three,
    KReportType? reportType,
  }) {
    if (type == KHealthDataType.BODY_TEMPERATURE) {
      return [
        TodayOverViewModel(title: "max_temp".tr, content: one),
        TodayOverViewModel(title: "low_temp".tr, content: two),
        TodayOverViewModel(title: "err_temp".tr, content: three),
      ];
    }
    if (type == KHealthDataType.BLOOD_OXYGEN) {
      return [
        TodayOverViewModel(title: "max_bloodoxygen".tr, content: one),
        TodayOverViewModel(title: "mininum_bloodoxygen".tr, content: two),
        TodayOverViewModel(title: "exception_number".tr, content: three),
      ];
    }
    if (type == KHealthDataType.SLEEP) {
      return reportType == KReportType.day
          ? [
              TodayOverViewModel(
                  title: KSleepStatusType.deepSleep.getStatusDesc(),
                  color: KSleepStatusType.deepSleep.getStatusColor(),
                  content: one),
              TodayOverViewModel(
                  title: KSleepStatusType.lightSleep.getStatusDesc(),
                  color: KSleepStatusType.lightSleep.getStatusColor(),
                  content: two),
              TodayOverViewModel(
                  title: KSleepStatusType.awake.getStatusDesc(),
                  color: KSleepStatusType.lightSleep.getStatusColor(),
                  content: three),
            ]
          : [
              TodayOverViewModel(title: "average_sleeptime".tr, content: one),
              TodayOverViewModel(
                  title: "average_deepsleeptime".tr, content: two),
              TodayOverViewModel(
                  title: "average_lighrsleeptime".tr, content: three),
            ];
    }
    return [
      TodayOverViewModel(title: "resting_heartrate".tr, content: one),
      TodayOverViewModel(title: "max_heartrate".tr, content: two),
      TodayOverViewModel(title: "min_heartrate".tr, content: three),
    ];
  }
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
