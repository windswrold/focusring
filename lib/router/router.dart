import 'package:get/get.dart';

class Routers {
  static Future<T?>? pushWidget<T>(
    dynamic page,
  ) {
    // Get.to(page);
    Get.to(() => page);
  }

  static void goBack<T>({
    T? result,
  }) {
    return Get.back(result: result);
  }

  static Future<T?>? replacePush<T>(
    dynamic page,
  ) {
    return Get.off(() => page);
  }

  static Future<T?>? removeAll<T>(
    dynamic page,
  ) {
    return Get.offAll(() => page);
  }
}
