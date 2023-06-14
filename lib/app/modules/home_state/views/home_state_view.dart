import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_state_controller.dart';

class HomeStateView extends GetView<HomeStateController> {
  const HomeStateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeStateView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'HomeStateView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
