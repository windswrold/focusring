import 'package:dotted_border/dotted_border.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class HomeEditCardController extends GetxController {
  //TODO: Implement HomeEditCardController

  RxList<DragAndDropList> datas = RxList.empty();

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
                type.getDisplayName(),
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

    datas = [
      DragAndDropList(
        header: _getItemTitle("edit_cardtip".tr),
        children: <DragAndDropItem>[
          DragAndDropItem(child: _getItemCard(KHealthDataType.BLOOD_OXYGEN)),
          DragAndDropItem(child: _getItemCard(KHealthDataType.SLEEP)),
          DragAndDropItem(child: _getItemCard(KHealthDataType.STEPS)),
        ],
      ),
      DragAndDropList(
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
        children: <DragAndDropItem>[
          DragAndDropItem(child: _getItemCard(KHealthDataType.HEART_RATE)),
          DragAndDropItem(child: _getItemCard(KHealthDataType.DISTANCE)),
          DragAndDropItem(child: _getItemCard(KHealthDataType.EMOTION)),
        ],
      )
    ].obs;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    var movedItem = datas[oldListIndex].children.removeAt(oldItemIndex);
    datas[newListIndex].children.insert(newItemIndex, movedItem);

    update();
  }

  onListReorder(int oldListIndex, int newListIndex) {
    var movedList = datas.removeAt(oldListIndex);
    datas.insert(newListIndex, movedList);
    update();
    ;
  }

  move1(int oldIndex, int newIndex) {
    // if (newIndex > list1.length) {
    //   newIndex -= (list1.length + 1); // Add 1 for header
    //   if (oldIndex > list1.length) {
    //     oldIndex -= (list1.length + 1);
    //   } else {
    //     oldIndex = -1; // Set to an invalid index so that it won't affect list1
    //   }
    //   ListItem item = list2.removeAt(oldIndex);
    //   list2.value.insert(newIndex, item);
    // } else if (oldIndex > list1.length) {
    //   ListItem item = list2.removeAt(oldIndex -
    //       (list1.length + 1)); // Subtract list1 length and 1 for header
    //   list1.value.insert(newIndex, item);
    // } else {
    //   ListItem item = list1.removeAt(oldIndex - 1); // Subtract 1 for header
    //   list1.value.insert(newIndex, item);
    // }
  }

  move2(int oldIndex, int newIndex) {}
}
