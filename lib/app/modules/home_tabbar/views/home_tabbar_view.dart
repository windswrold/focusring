import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:beering/app/modules/home_devices/views/home_devices_view.dart';
import 'package:beering/app/modules/home_mine/views/home_mine_view.dart';
import 'package:beering/app/modules/home_state/views/home_state_view.dart';

import 'package:get/get.dart';

import '../../../../public.dart';
import '../controllers/home_tabbar_controller.dart';

class HomeTabbarView extends GetView<HomeTabbarController> {
  HomeTabbarView({Key? key}) : super(key: key);

  get items => [
        BottomNavigationBarItem(
            icon: _getIcon("tabbar/tab_status_normal"),
            activeIcon: _getIcon("tabbar/tab_status_sel"),
            label: "tabbar_status".tr),
        BottomNavigationBarItem(
            icon: _getIcon("tabbar/tab_device_normal"),
            activeIcon: _getIcon("tabbar/tab_device_sel"),
            label: "tabbar_devices".tr),
        BottomNavigationBarItem(
            icon: _getIcon("tabbar/tab_mine_normal"),
            activeIcon: _getIcon("tabbar/tab_mine_sel"),
            label: "tabbar_mine".tr),
      ];

  Widget _getIcon(String image) {
    return LoadAssetsImage(
      image,
      width: 48,
      height: 24,
    );
  }

  List<Widget> bodyList = [
    HomeStateView(),
    HomeDevicesView(),
    HomeMineView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.bleIsok.value == true) {
        return Scaffold(
            bottomNavigationBar: Theme(
                data: ThemeData(
                    splashColor: const Color.fromRGBO(0, 0, 0, 0),
                    highlightColor: const Color.fromRGBO(0, 0, 0, 0)),
                child: BottomNavigationBar(
                  items: items,
                  currentIndex: controller.currentIndex.value,
                  onTap: (a) {
                    controller.onTap(a);
                  },
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor:
                      Get.theme.bottomNavigationBarTheme.backgroundColor,
                  selectedItemColor:
                      Get.theme.bottomNavigationBarTheme.selectedItemColor,
                  unselectedItemColor:
                      Get.theme.bottomNavigationBarTheme.unselectedItemColor,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                )),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                IndexedStack(
                  index: controller.currentIndex.value,
                  children: bodyList,
                ),
              ],
            ));
      } else {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 250.w),
                  child: LoadAssetsImage(
                    "icons/app_icon",
                    width: 55,
                    height: 55,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.w),
                  child: Text(
                    "${"request_we".tr} Bee Ring",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(top: 10.w),
                  child: RichText(
                    text: TextSpan(
                      text: "request_tip".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.w, bottom: 30.w),
                  child: RichText(
                      text: TextSpan(
                    text: "request_cle".tr,
                    children: [
                      TextSpan(
                        text: " '${"agree".tr}' ",
                      ),
                      TextSpan(
                        text: "request_tip02".tr,
                      ),
                      TextSpan(
                        text: "request_tip04".tr,
                        style: Get.textTheme.titleMedium,
                        recognizer: controller.tap,
                      ),
                      TextSpan(
                        text: "request_tip05".tr,
                      ),
                      TextSpan(
                        text: "request_tip06".tr,
                        style: Get.textTheme.titleMedium,
                        recognizer: controller.tap,
                      ),
                    ],
                  )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: NextButton(
                          onPressed: () {
                            controller.cancel();
                          },
                          // width: 150,
                          height: 40,
                          margin: EdgeInsets.only(bottom: 40),
                          textStyle: Get.textTheme.displayLarge,
                          title: "disagree".tr),
                    ),
                    50.rowWidget,
                    Expanded(
                      child: NextButton(
                        onPressed: () {
                          controller.confirm();
                        },
                        // width: 150,
                        textStyle: Get.textTheme.titleMedium,
                        margin: EdgeInsets.only(bottom: 40),
                        height: 40,
                        title: "agree".tr,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
