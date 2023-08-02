import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/report_info_emotion_controller.dart';

class ReportInfoEmotionView extends GetView<ReportInfoEmotionController> {
  const ReportInfoEmotionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReportInfoEmotionView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ReportInfoEmotionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
