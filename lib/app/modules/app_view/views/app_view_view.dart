import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:beering/app/routes/app_pages.dart';
import 'package:beering/generated/locales.g.dart';
import 'package:beering/theme/theme.dart';
import 'package:beering/utils/localeManager.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../public.dart';
import '../controllers/app_view_controller.dart';

class AppViewView extends GetView<AppViewController> {
  const AppViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: kDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return RefreshConfiguration(
          headerBuilder: () => WaterDropHeader(),
          footerBuilder: () => ClassicFooter(),
          headerTriggerDistance:
              80.0, // header trigger refresh trigger distance
          springDescription: SpringDescription(
              stiffness: 170,
              damping: 16,
              mass:
                  1.9), // custom spring back animate,the props meaning see the flutter api
          maxOverScrollExtent:
              100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
          maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
          enableScrollWhenRefreshCompleted:
              true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
          enableLoadingWhenFailed:
              true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
          hideFooterWhenNotFull:
              false, // Disable pull-up to load more functionality when Viewport is less than one screen
          enableBallisticLoad: true,
          child: GetMaterialApp(
            title: "",
            theme: KTheme.light,
            darkTheme: KTheme.dark,
            themeMode: ThemeMode.dark,
            initialRoute: AppPages.INITIAL,
            builder: BotToastInit(), //1. call BotToastInit
            navigatorObservers: [BotToastNavigatorObserver()],
            locale: toLocale(SPManager.getAppLanguage()),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            translationsKeys: AppTranslation.translations,
            supportedLocales: AppTranslation.translations.keys
                .map((e) => toLocale(e))
                .toList(),
            fallbackLocale: fallbackLocale,
            getPages: AppPages.routes,
          ),
        );
      },
    );
  }
}



class Test extends StatefulWidget {
  Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  Widget _getQuestionType() {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48.w,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: "feed_question".tr,
                style: Get.textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: " *",
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: ColorUtils.fromHex("#FFFF0000"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Obx(
          //   () => Wrap(
          //     runSpacing: 12.w,
          //     spacing: 10.w,
          //     children: controller.datas
          //         .map(
          //           (element) => IntrinsicWidth(
          //             child: NextButton(
          //               onPressed: () {
          //                 // controller.onTapList(element);
          //               },
          //               title: element.tr,
          //               borderRadius: 14,
          //               padding: EdgeInsets.symmetric(
          //                   horizontal: 16.w, vertical: 8.w),
          //               activeColor: ColorUtils.fromHex("#FF000000"),
          //               // textStyle: controller.chooseStr.value == element
          //               //     ? Get.textTheme.displaySmall?.copyWith(
          //               //         color: ColorUtils.fromHex("#FF05E6E7"))
          //               //     : Get.textTheme.displaySmall,
          //               // border: controller.chooseStr.value == element
          //               //     ? Border.all(color: ColorUtils.fromHex("#FF05E6E7"))
          //               //     : null,
          //             ),
          //           ),
          //         )
          //         .toList(),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _getFeedInput() {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48.w,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: "feed_desc".tr,
                style: Get.textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: " *",
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: ColorUtils.fromHex("#FFFF0000"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ColorUtils.fromHex("#FF000000"),
            ),
            child: TextField(
              maxLines: 10,
              maxLength: 1000,
              style: Get.textTheme.displayLarge,
              // controller: controller.remarEC,
              decoration: InputDecoration(
                hintStyle: Get.textTheme.bodyMedium,
                hintText: "feed_input".tr,
                filled: true,
                fillColor: ColorUtils.fromHex("#FF000000"),
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                counterStyle: Get.textTheme.displaySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFeedTel() {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48.w,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: "feed_tel".tr,
                style: Get.textTheme.bodySmall,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: TextField(
              maxLines: 1,
              style: Get.textTheme.displayLarge,
              // controller: controller.phoneEC,
              decoration: InputDecoration(
                hintStyle: Get.textTheme.bodyMedium,
                hintText: "feed_teldesc".tr,
                filled: true,
                fillColor: ColorUtils.fromHex("#FF000000"),
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                counterStyle: Get.textTheme.displaySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // titleStr: "Feedback".tr,
      // hiddenResizeToAvoidBottomInset: true,
      body: Container(
        // alignment: Alignment.center,
        width: 375.w,
        height: 812.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _getFeedInput(),
              _getFeedInput(),
              _getFeedInput(),
              _getFeedInput(),
              _getFeedInput(),
            ],
          ),
        ),

        //   Column(
        //     children: [
        //       _getQuestionType(),
        //       _getFeedInput(),
        //       _getFeedInput(),
        //       _getFeedTel(),
        //       Container(
        //         padding: EdgeInsets.only(right: 12.w),
        //         child: Row(
        //           children: [
        //             // Obx(
        //             //   () => IconButton(
        //             //     onPressed: () {
        //             //       // controller.switchState();
        //             //     },
        //             //     iconSize: 20,
        //             //     icon: LoadAssetsImage(
        //             //       true== true
        //             //           ? "icons/state_true"
        //             //           : "icons/state_false",
        //             //     ),
        //             //   ),
        //             // ),
        //             Expanded(
        //               child: Text(
        //                 "feed_upload".tr,
        //                 style: Get.textTheme.labelLarge,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       NextButton(
        //         onPressed: () {
        //           // controller.startReport();
        //         },
        //         title: "submit".tr,
        //         margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.w),
        //         textStyle: Get.textTheme.displayLarge,
        //         height: 44.w,
        //         gradient: LinearGradient(colors: [
        //           ColorUtils.fromHex("#FF0E9FF5"),
        //           ColorUtils.fromHex("#FF02FFE2"),
        //         ]),
        //         borderRadius: 22,
        //       )
        //     ],
        //   ),
      ),
    );
  }
}
