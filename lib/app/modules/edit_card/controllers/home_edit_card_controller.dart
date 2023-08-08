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

    datas = [
      DragAndDropList(
        header: _getItemTitle("edit_cardtip".tr),
        children: KHealthDataType.values
            .map((e) => DragAndDropItem(child: _getItemCard(e)))
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
        children: <DragAndDropItem>[
          DragAndDropItem(child: _getItemCard(KHealthDataType.HEART_RATE)),
          DragAndDropItem(child: _getItemCard(KHealthDataType.LiCheng)),
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

  void onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    var movedItem = datas[oldListIndex].children.removeAt(oldItemIndex);
    datas[newListIndex].children.insert(newItemIndex, movedItem);

    vmPrint(datas.toJson());

    update();
  }

  void onListReorder(int oldListIndex, int newListIndex) {
    var movedList = datas.removeAt(oldListIndex);
    datas.insert(newListIndex, movedList);
    update();
  }
}
