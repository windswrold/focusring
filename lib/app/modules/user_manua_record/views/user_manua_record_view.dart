import 'package:flutter/material.dart';
import 'package:beering/public.dart';

import 'package:get/get.dart';

import '../controllers/user_manua_record_controller.dart';

class UserManuaRecordView extends GetView<UserManuaRecordController> {
  const UserManuaRecordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
        titleStr: "manual_record".tr,
        body: Column(
          children: [],
        ));
  }
}
