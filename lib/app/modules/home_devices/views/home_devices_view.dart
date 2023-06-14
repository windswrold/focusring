import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_devices_controller.dart';

class HomeDevicesView extends GetView<HomeDevicesController> {
  const HomeDevicesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeDevicesView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'HomeDevicesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
