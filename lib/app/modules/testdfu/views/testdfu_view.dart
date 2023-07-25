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
                  controller: controller.copy1,
                  decoration: InputDecoration(
                    hintText: "拷贝地址(不包含0x)",
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.copyDFU();
                },
                child: Text("拷贝升级"),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              controller.fastDFU();
            },
            child: Text("fast普通升级，小升大"),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.copy2,
                  decoration: InputDecoration(
                    hintText: "fast拷贝地址(不包含0x)",
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.fastCopyDFU();
                },
                child: Text("fast拷贝升级"),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.copy3,
                  decoration: InputDecoration(
                    hintText: "资源地址(不包含0x)",
                  ),
                ),
              ),
              Obx(
                () => Switch(
                    value: controller.isExtFlash.value,
                    onChanged: (e) {
                      controller.onChange(e);
                    }),
              ),
              Text("外部Flash"),
              TextButton(
                onPressed: () {
                  controller.fastDFUResource();
                },
                child: Text("fast资源升级"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
