import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_tabbar_controller.dart';

class HomeTabbarView extends GetView<HomeTabbarController> {
  const HomeTabbarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeTabbarView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'HomeTabbarView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
