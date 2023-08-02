import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/report_info_stress_controller.dart';

class ReportInfoStressView extends GetView<ReportInfoStressController> {
  const ReportInfoStressView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReportInfoStressView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ReportInfoStressView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
