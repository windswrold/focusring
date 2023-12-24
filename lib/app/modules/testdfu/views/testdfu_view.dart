import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:beering/ble/ble_config.dart';
import 'package:beering/ble/ble_manager.dart';
import 'package:beering/public.dart';

import 'package:get/get.dart';

import '../controllers/testdfu_controller.dart';

class TestdfuView extends GetView<TestdfuController> {
  const TestdfuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "App Log",
      body: Column(
        children: [
          // Obx(
          //   () => Text("选择文件 ${controller.currentFile.value}"),
          // ),
          // TextButton(
          //   onPressed: () {
          //     controller.openFile();
          //   },
          //   child: Text("选择文件"),
          // ),
          // Text("升级操作"),
          // Row(
          //   children: [
          //     Obx(
          //       () => Switch(
          //           value: controller.isfastMode.value,
          //           onChanged: (e) {
          //             controller.onChange(e);
          //           }),
          //     ),
          //     Text("isfastMode"),
          //   ],
          // ),
          // TextButton(
          //   onPressed: () {
          //     controller.normalDFU();
          //   },
          //   child: Text("普通升级，小升大"),
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: TextField(
          //         controller: controller.copy1,
          //         decoration: InputDecoration(
          //           hintText: "拷贝地址(不包含0x)",
          //         ),
          //       ),
          //     ),
          //     TextButton(
          //       onPressed: () {
          //         controller.copyDFU();
          //       },
          //       child: Text("拷贝升级"),
          //     ),
          //   ],
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: TextField(
          //         controller: controller.copy2,
          //         decoration: InputDecoration(
          //           hintText: "发送任意命令(不包含0x)",
          //         ),
          //       ),
          //     ),
          //     TextButton(
          //       onPressed: () {
          //         controller.sendcustom();
          //       },
          //       child: Text("发送任意命令"),
          //     ),
          //   ],
          // ),
          // TextField(
          //   controller: controller.copy3,
          //   decoration: InputDecoration(
          //     hintText: "cmd(不包含0x)",
          //   ),
          // ),
          // TextField(
          //   controller: controller.copy4,
          //   decoration: InputDecoration(
          //     hintText: "type(不包含0x)",
          //   ),
          // ),
          // TextField(
          //   controller: controller.copy5,
          //   decoration: InputDecoration(
          //     hintText: "value(不包含0x)",
          //   ),
          // ),
          // TextButton(
          //   onPressed: () {
          //     BLESendData send = BLESendData(
          //         cmd: null,
          //         cmdStr: controller.copy3.text,
          //         typeStr: controller.copy4.text,
          //         valueStr: controller.copy5.text);

          //     controller.sendota(send);
          //   },
          //   child: Text("发送构造命令"),
          // ),
          // const Text("收到的数据"),
          TextButton(
            onPressed: () {
              controller.shareLog();
            },
            child: Text("导出Log"),
          ),
          GetBuilder<AppViewController>(
            tag: AppViewController.tag,
            id: "logController",
            builder: (a) {
              return Expanded(
                child: ListView.builder(
                  itemCount: a.receDatas.length,
                  itemBuilder: (BuildContext context, int index) {
                    final value = a.receDatas[index];
                    return Text(value);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
