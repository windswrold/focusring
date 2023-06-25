import 'package:focusring/const/constant.dart';

import 'home_card_x.dart';

class KHealthDataClass {
  KHealthData? type;
  String? date;
  String? result;
  String? resultDesc;

  String? startDesc;
  String? endDesc;

  int? index;
  bool? state;

  List<HomeCardItemModel> datas = [];

  KHealthDataClass({this.type = KHealthData.STEPS});
}
