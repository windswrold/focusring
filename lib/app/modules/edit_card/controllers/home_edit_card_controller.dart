import 'package:dotted_border/dotted_border.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:focusring/app/data/card_health_index.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class HomeEditCardController extends GetxController {
  //TODO: Implement HomeEditCardController

  RxList<DragAndDropList> datas = RxList.empty();

  List<KHealthIndexModel> _visibleItems = [];
  List<KHealthIndexModel> _hiddenItems = [];

  Widget _getItemCard(KHealthDataType type) {
    return Container(
      height: 54.w,
      key: ValueKey(type),
      margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 1),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FF000000"),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              LoadAssetsImage(
                type.getIcon(isCardIcon: true),
                width: 35,
                height: 35,
              ),
              8.rowWidget,
              Text(
                type.getDisplayName(isReport: true),
                style: Get.textTheme.labelLarge,
              ),
            ],
          ),
          LoadAssetsImage(
            "icons/editcard_icon_order",
            width: 20,
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _getItemTitle(String title) {
    return Container(
      key: ValueKey(title),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      child: Text(
        title,
        style: Get.textTheme.labelMedium,
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();

    _initData();
  }

  void _initData() async {
    final appUserId = await SPManager.getPhoneID();
    _visibleItems = await KHealthIndexModel.queryAllWithState(appUserId, true);
    _hiddenItems = await KHealthIndexModel.queryAllWithState(appUserId, false);
    _updateData();
  }

  void _updateData() {
    datas.value = [
      DragAndDropList(
        header: _getItemTitle("edit_cardtip".tr),
        children: _visibleItems
            .map((e) => DragAndDropItem(child: _getItemCard(e.type)))
            .toList(),
        canDrag: false,
      ),
      DragAndDropList(
          canDrag: false,
          header: _getItemTitle("hidden_Items".tr),
          contentsWhenEmpty: DottedBorder(
            color: ColorUtils.fromHex("#FF3C454A"),
            strokeWidth: 1,
            radius: Radius.circular(60),
            child: Container(
              height: 81.w,
              width: 351.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadAssetsImage(
                    "icons/editcard_icon_hide",
                    width: 39,
                    height: 37,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.w),
                    child: Text(
                      "hidden_Itemsdesc".tr,
                      style: Get.textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          children: _hiddenItems
              .map((e) => DragAndDropItem(child: _getItemCard(e.type)))
              .toList())
    ];
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
    // var movedItem = datas[oldListIndex].children.removeAt(oldItemIndex);
    // datas[newListIndex].children.insert(newItemIndex, movedItem);
    // update();
    vmPrint(
        "oldItemIndex $oldItemIndex  $oldListIndex  $newItemIndex $newListIndex ");

    KHealthIndexModel draggedItem;

    // 从旧列表中提取被拖动的项
    if (oldListIndex == 0) {
      // 显示列表
      draggedItem = _visibleItems[oldItemIndex];
      _visibleItems.removeAt(oldItemIndex);
    } else {
      // 隐藏列表
      draggedItem = _hiddenItems[oldItemIndex];
      _hiddenItems.removeAt(oldItemIndex);
    }

    // 插入到新的位置
    if (newListIndex == 0) {
      // 显示列表
      _visibleItems.insert(newItemIndex, draggedItem);
      draggedItem.state = true; // 设置为可见
    } else {
      // 隐藏列表
      _hiddenItems.insert(newItemIndex, draggedItem);
      draggedItem.state = false; // 设置为隐藏
    }

    // // 更新index字段
    // for (int i = 0; i < _visibleItems.length; i++) {
    //   _visibleItems[i].index = i;
    // }
    // for (int i = 0; i < _hiddenItems.length; i++) {
    //   _hiddenItems[i].index = i;
    // }

    update();
  }

  void onListReorder(int oldListIndex, int newListIndex) {
    vmPrint("onListReorder $oldListIndex   $newListIndex ");
    var movedList = datas.removeAt(oldListIndex);
    datas.insert(newListIndex, movedList);
    update();
  }
}
