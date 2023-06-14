import 'package:flutter/cupertino.dart';
import 'package:focusring/pages/import/controllers/current_wallet_state.dart';

import '../../../public.dart';

class PImportWallet extends GetView<KCurrentWalletController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('MyPage')),
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoButton(
              child: Text("label".tr),
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
            CupertinoButton(
              child: Text("local".tr),
              onPressed: (() {
                
                
              }),
            ),
          ],
        )));
  }
}
