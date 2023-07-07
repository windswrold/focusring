import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/report_info_heartrate_controller.dart';

class ReportInfoHeartrateView extends GetView<ReportInfoHeartrateController> {
  const ReportInfoHeartrateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReportInfoHeartrateView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ReportInfoHeartrateView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
