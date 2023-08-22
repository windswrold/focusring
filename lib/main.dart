import 'package:beering/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:beering/app/modules/app_view/views/app_view_view.dart';
import 'package:beering/public.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalValues.init();
  Get.put(AppViewController(), tag: AppViewController.tag);
  runApp(AppViewView());
}
