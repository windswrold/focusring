import 'package:flutter/material.dart';
import 'package:focusring/views/base/base_pageview.dart';

import 'package:get/get.dart';

import '../controllers/home_mine_controller.dart';

class HomeMineView extends GetView<HomeMineController> {
  const HomeMineView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      body: Center(
        child: Text(
          'HomeMineView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
