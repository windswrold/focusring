import 'package:focusring/views/dialog_widgets/views/dialog_modify_goals.dart';

import '../../public.dart';

class DialogUtils {
  DialogUtils._();

  static dialogModifyGoals() {
    return Get.bottomSheet(DialogModifyGoalsPage());
  }
}
