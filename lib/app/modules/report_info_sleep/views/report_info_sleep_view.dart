import 'package:flutter/material.dart';
import 'package:focusring/views/base/base_pageview.dart';

import 'package:get/get.dart';

import '../controllers/report_info_sleep_controller.dart';

class ReportInfoSleepView extends GetView<ReportInfoSleepController> {
  const ReportInfoSleepView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "sleep_report".tr,
      body: Center(
        child: Text(
          'ReportInfoSleepView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
