import 'package:beering/const/constant.dart';

import 'home_card_x.dart';

class KHomeCardModel {
  final KHealthDataType? type;
  final String? date;
  final String? result;
  final String? resultDesc;

  final String? startDesc;
  final String? endDesc;

  final int? index;
  final bool? state;

  final List<List<KChartCellData>>? datas;

  final double? maximum;

  KHomeCardModel({
    this.maximum,
    this.date,
    this.result,
    this.resultDesc,
    this.startDesc,
    this.endDesc,
    this.index,
    this.state,
    this.type = KHealthDataType.STEPS,
    this.datas,
  });
}
