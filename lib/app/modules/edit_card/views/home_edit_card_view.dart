import 'package:flutter/material.dart';
import 'package:focusring/utils/console_logger.dart';

import 'package:get/get.dart';

import '../../../../public.dart';
import '../controllers/home_edit_card_controller.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';

class HomeEditCardView extends GetView<HomeEditCardController> {
  const HomeEditCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "edit_card".tr,
      body: GetBuilder(
        init: controller,
        builder: ((_) => DragAndDropLists(
              children: controller.datas,
              removeTopPadding: true,
              listDragOnLongPress: false,
              lastItemTargetHeight: 10,
              onItemReorder: controller.onItemReorder,
              onListReorder: controller.onListReorder,
            )),
      ),
    );
  }
}
