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
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    _buildText(),
                    _buildText(),
                    _buildText(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
    return Container(
      child: Row(
        children: [
          Text("data", style: Get.textTheme.titleLarge),
          Text("data"),
          Text("data"),
        ],
      ),
    );
  }
}
