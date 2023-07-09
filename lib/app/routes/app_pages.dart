import 'package:get/get.dart';

import '../modules/about_us/bindings/about_us_binding.dart';
import '../modules/about_us/views/about_us_view.dart';
import '../modules/app_view/bindings/app_view_binding.dart';
import '../modules/app_view/views/app_view_view.dart';
import '../modules/automatic_settings/bindings/automatic_settings_binding.dart';
import '../modules/automatic_settings/views/automatic_settings_view.dart';
import '../modules/device_info/bindings/device_info_binding.dart';
import '../modules/device_info/views/device_info_view.dart';
import '../modules/edit_card/bindings/home_edit_card_binding.dart';
import '../modules/edit_card/views/home_edit_card_view.dart';
import '../modules/edit_mygoals/bindings/edit_mygoals_binding.dart';
import '../modules/edit_mygoals/views/edit_mygoals_view.dart';
import '../modules/faq_view/bindings/faq_view_binding.dart';
import '../modules/faq_view/views/faq_view_view.dart';
import '../modules/find_devices/bindings/find_devices_binding.dart';
import '../modules/find_devices/views/find_devices_view.dart';
import '../modules/heartrate_alert/bindings/heartrate_alert_binding.dart';
import '../modules/heartrate_alert/views/heartrate_alert_view.dart';
import '../modules/home_devices/bindings/home_devices_binding.dart';
import '../modules/home_devices/views/home_devices_view.dart';
import '../modules/home_mine/bindings/home_mine_binding.dart';
import '../modules/home_mine/views/home_mine_view.dart';
import '../modules/home_state/bindings/home_state_binding.dart';
import '../modules/home_state/views/home_state_view.dart';
import '../modules/home_tabbar/bindings/home_tabbar_binding.dart';
import '../modules/home_tabbar/views/home_tabbar_view.dart';
import '../modules/language_unit/bindings/language_unit_binding.dart';
import '../modules/language_unit/views/language_unit_view.dart';
import '../modules/report_info_steps/bindings/report_info_steps_binding.dart';
import '../modules/report_info_steps/views/report_info_steps_view.dart';
import '../modules/setting_feedback/bindings/setting_feedback_binding.dart';
import '../modules/setting_feedback/views/setting_feedback_view.dart';
import '../modules/setting_user_info/bindings/setting_user_info_binding.dart';
import '../modules/setting_user_info/views/setting_user_info_view.dart';
import '../modules/unit_system/bindings/unit_system_binding.dart';
import '../modules/unit_system/views/unit_system_view.dart';
import '../modules/user_manualtest/bindings/user_manualtest_binding.dart';
import '../modules/user_manualtest/views/user_manualtest_view.dart';

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
    GetPage(
      name: _Paths.LANGUAGE_UNIT,
      page: () => const LanguageUnitView(),
      binding: LanguageUnitBinding(),
    ),
    GetPage(
      name: _Paths.UNIT_SYSTEM,
      page: () => const UnitSystemView(),
      binding: UnitSystemBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_USER_INFO,
      page: () => const SettingUserInfoView(),
      binding: SettingUserInfoBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_FEEDBACK,
      page: () => const SettingFeedbackView(),
      binding: SettingFeedbackBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_US,
      page: () => const AboutUsView(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: _Paths.FAQ_VIEW,
      page: () => const FaqViewView(),
      binding: FaqViewBinding(),
    ),
    GetPage(
      name: _Paths.DEVICE_INFO,
      page: () => const DeviceInfoView(),
      binding: DeviceInfoBinding(),
    ),
    GetPage(
      name: _Paths.HEARTRATE_ALERT,
      page: () => const HeartrateAlertView(),
      binding: HeartrateAlertBinding(),
    ),
    GetPage(
      name: _Paths.AUTOMATIC_SETTINGS,
      page: () => const AutomaticSettingsView(),
      binding: AutomaticSettingsBinding(),
    ),
    GetPage(
      name: _Paths.FIND_DEVICES,
      page: () => const FindDevicesView(),
      binding: FindDevicesBinding(),
    ),
    GetPage(
      name: _Paths.APP_VIEW,
      page: () => const AppViewView(),
      binding: AppViewBinding(),
    ),
    GetPage(
        name: _Paths.USER_MANUALTEST,
        page: () => const UserManualtestView(),
        binding: UserManualtestBinding()),
    GetPage(
      name: _Paths.REPORT_INFO_STEPS,
      page: () => const ReportInfoStepsView(),
      binding: ReportInfoStepsBinding(),
    ),
  ];
}
