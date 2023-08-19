import 'package:dotted_border/dotted_border.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:focusring/app/data/card_health_index.dart';
import 'package:focusring/app/modules/home_state/controllers/home_state_controller.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class HomeEditCardController extends GetxController {
  //TODO: Implement HomeEditCardController

  RxList<KHealthIndexModel> visibleItems = <KHealthIndexModel>[].obs;
  RxList<KHealthIndexModel> hiddenItems = <KHealthIndexModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    _initData();
  }

  void _initData() async {
    final appUserId = await SPManager.getPhoneID();
    visibleItems.value =
        await KHealthIndexModel.queryAllWithState(appUserId, true);
    visibleItems.value = visibleItems
        .where((p0) => p0.type != KHealthDataType.BLOOD_OXYGEN)
        .where((p0) => p0.type != KHealthDataType.HEART_RATE)
        .toList();

    //     if (element.type == KHealthDataType.BLOOD_OXYGEN ||
    //     element.type == KHealthDataType.HEART_RATE) {
    //   continue;
    // }
    hiddenItems.value =
        await KHealthIndexModel.queryAllWithState(appUserId, false);
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    KHealthIndexModel draggedItem;
    try {
      // 从旧列表中提取被拖动的项
      if (oldListIndex == 0) {
        // 显示列表
        draggedItem = visibleItems[oldItemIndex];
        visibleItems.removeAt(oldItemIndex);
      } else {
        // 隐藏列表
        draggedItem = hiddenItems[oldItemIndex];
        hiddenItems.removeAt(oldItemIndex);
      }
      // // 插入到新的位置
      if (newListIndex == 0) {
        // 显示列表
        visibleItems.insert(newItemIndex, draggedItem);
        draggedItem.state = true; // 设置为可见
      } else {
        // 隐藏列表
        hiddenItems.insert(newItemIndex, draggedItem);
        draggedItem.state = false; // 设置为隐藏
      }

      // 更新index字段
      for (int i = 0; i < visibleItems.length; i++) {
        visibleItems[i].index = i;
      }
      for (int i = 0; i < hiddenItems.length; i++) {
        hiddenItems[i].index = i;
      }

      KHealthIndexModel.updateTokens(visibleItems);
      KHealthIndexModel.updateTokens(hiddenItems);
      update();
      final c = Get.find<HomeStateController>();
      c.initData();
    } catch (e) {
      vmPrint(e.toString());
    }
  }

  void onListReorder(int oldListIndex, int newListIndex) {
    vmPrint("onListReorder $oldListIndex   $newListIndex ");
  }
}
