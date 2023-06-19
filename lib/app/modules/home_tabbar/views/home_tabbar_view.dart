import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:focusring/app/modules/home_devices/views/home_devices_view.dart';
import 'package:focusring/app/modules/home_mine/views/home_mine_view.dart';
import 'package:focusring/app/modules/home_state/views/home_state_view.dart';

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
            activeIcon: _getIcon("tabbar/tab_mine_normal"),
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
    });
  }
}
