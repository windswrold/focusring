import 'package:get/get.dart';

import '../modules/edit_card/bindings/home_edit_card_binding.dart';
import '../modules/edit_card/views/home_edit_card_view.dart';
import '../modules/edit_mygoals/bindings/edit_mygoals_binding.dart';
import '../modules/edit_mygoals/views/edit_mygoals_view.dart';
import '../modules/home_devices/bindings/home_devices_binding.dart';
import '../modules/home_devices/views/home_devices_view.dart';
import '../modules/home_mine/bindings/home_mine_binding.dart';
import '../modules/home_mine/views/home_mine_view.dart';
import '../modules/home_state/bindings/home_state_binding.dart';
import '../modules/home_state/views/home_state_view.dart';
import '../modules/home_tabbar/bindings/home_tabbar_binding.dart';
import '../modules/home_tabbar/views/home_tabbar_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME_TABBAR;

  static final routes = [
    GetPage(
      name: _Paths.HOME_DEVICES,
      page: () => const HomeDevicesView(),
      binding: HomeDevicesBinding(),
    ),
    GetPage(
      name: _Paths.HOME_MINE,
      page: () => const HomeMineView(),
      binding: HomeMineBinding(),
    ),
    GetPage(
      name: _Paths.HOME_STATE,
      page: () => const HomeStateView(),
      binding: HomeStateBinding(),
    ),
    GetPage(
      name: _Paths.HOME_TABBAR,
      page: () => HomeTabbarView(),
      binding: HomeTabbarBinding(),
    ),
    GetPage(
      name: _Paths.HOME_EDIT_CARD,
      page: () => const HomeEditCardView(),
      binding: HomeEditCardBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_MYGOALS,
      page: () => const EditMygoalsView(),
      binding: EditMygoalsBinding(),
    ),
  ];
}
