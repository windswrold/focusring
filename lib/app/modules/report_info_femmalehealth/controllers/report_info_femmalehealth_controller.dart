import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ReportInfoFemmalehealthController extends GetxController {
  //TODO: Implement ReportInfoFemmalehealthController

  late DateRangePickerController rangePickerController =
      DateRangePickerController();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    rangePickerController.selectedDate = DateTime.now();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
