import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:focusring/views/base/base_pageview.dart';

import 'package:get/get.dart';

import '../controllers/common_html_view_controller.dart';

class CommonHtmlViewView extends GetView<CommonHtmlViewController> {
  const CommonHtmlViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      body: Container(
        color: Colors.white,
        child: HtmlWidget(
          Get.arguments,
          renderMode: RenderMode.listView,
          customWidgetBuilder: (element) {
            if (element.localName == "title") {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
