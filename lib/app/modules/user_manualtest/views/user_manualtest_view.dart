import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_manualtest_controller.dart';

class UserManualtestView extends GetView<UserManualtestController> {
  const UserManualtestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserManualtestView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'UserManualtestView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
