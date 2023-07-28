import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:focusring/app/modules/app_view/views/app_view_view.dart';
import 'package:focusring/generated/locales.g.dart';
import 'package:focusring/public.dart';
import 'package:focusring/theme/theme.dart';
import 'package:focusring/utils/localeManager.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/modules/app_view/controllers/app_view_controller.dart';
import 'app/routes/app_pages.dart';
import 'const/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalValues.init();
  final controller = Get.put(AppViewController(), tag: AppViewController.tag);
  runApp(AppViewView());
}
