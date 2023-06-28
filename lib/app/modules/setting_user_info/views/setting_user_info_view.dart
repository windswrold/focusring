import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_user_info_controller.dart';

class SettingUserInfoView extends GetView<SettingUserInfoController> {
  const SettingUserInfoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingUserInfoView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SettingUserInfoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
