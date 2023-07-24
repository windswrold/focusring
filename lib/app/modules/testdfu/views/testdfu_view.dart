import 'package:flutter/material.dart';
import 'package:focusring/public.dart';

import 'package:get/get.dart';

import '../controllers/testdfu_controller.dart';

class TestdfuView extends GetView<TestdfuController> {
  const TestdfuView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "Test dfu",
      body: Column(
        children: [
          Obx(
            () => Text("选择文件 ${controller.currentFile.value}"),
          ),
          TextButton(
            onPressed: () {
              controller.openFile();
            },
            child: Text("选择文件"),
          ),
          Text("升级操作"),
          TextButton(
            onPressed: () {
              controller.normalDFU();
            },
            child: Text("普通升级，小升大"),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.textEditingController,
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.normalDFU();
                },
                child: Text("拷贝升级"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
