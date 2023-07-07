import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/report_info_bloodoxygen_controller.dart';

class ReportInfoBloodoxygenView
    extends GetView<ReportInfoBloodoxygenController> {
  const ReportInfoBloodoxygenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReportInfoBloodoxygenView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ReportInfoBloodoxygenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
