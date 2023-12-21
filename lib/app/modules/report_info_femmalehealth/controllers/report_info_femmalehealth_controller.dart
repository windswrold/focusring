import 'package:beering/public.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../data/user_info.dart';

class ReportInfoFemmalehealthController extends GetxController {
  //TODO: Implement ReportInfoFemmalehealthController

  late DateRangePickerController rangePickerController =
      DateRangePickerController();

  RxBool femmalState = RxBool(false); //女性健康是否设置

  String? lastPeriodStartTime;
  int? periodDuration;
  int? periodStartInterval;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  void _initData() {
    UserInfoModel? model = SPManager.getGlobalUser();
    femmalState.value = model?.femmalState() ?? false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
