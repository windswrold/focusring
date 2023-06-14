import 'package:flutter/cupertino.dart';
import 'package:focusring/pages/import/controllers/current_wallet_state.dart';
import 'package:focusring/public.dart';


class PImportBWallet extends GetView<KCurrentWalletController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('PImportBWallet')),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              child: Text("点击"),
              onPressed: (() {
                controller.addCount();
              }),
            ),
            Obx(() {
              return Text("count = ${controller.count.value}");
            }),
            CupertinoButton(
              child: Text("跳转"),
              onPressed: (() {
                controller.pushB();
              }),
            ),
          ],
        )));
  }
}
