import 'constant.dart';

class KReportQueryTimeUpdate {
  final DateTime time;

  KReportQueryTimeUpdate(this.time);
}

//数据完成
class KReportQueryDataUpdate {
  KHealthDataType? refreType;

  KReportQueryDataUpdate({this.refreType});
}
