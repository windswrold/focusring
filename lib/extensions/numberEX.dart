import '../public.dart';

extension offsetEX on num {
  Widget get rowWidget => SizedBox(width: w);
  Widget get columnWidget => SizedBox(height: w);

  // KUnits get getUnits => this == 1 ? KUnits.metric : KUnits.imperial;

  // KTempUnits get getTempUnits =>
  //     this == 1 ? KTempUnits.celsius : KTempUnits.fahrenheit;
}
