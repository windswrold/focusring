import '../public.dart';

extension offsetEX on num {
  Widget get rowWidget => SizedBox(width: w);
  Widget get columnWidget => SizedBox(height: w);

  // KUnits get getUnits => this == 1 ? KUnits.metric : KUnits.imperial;

  // KTempUnits get getTempUnits =>
  //     this == 1 ? KTempUnits.celsius : KTempUnits.fahrenheit;
}

extension DateTimeEX on DateTime {
  DateTime previousMonth() {
    if (month == 1) {
      return DateTime(year - 1, 12, day);
    } else {
      return DateTime(year, month - 1, day);
    }
  }

  DateTime nextMonth() {
    if (month == 12) {
      return DateTime(year + 1, 1, day);
    } else {
      return DateTime(year, month + 1, day);
    }
  }
}
