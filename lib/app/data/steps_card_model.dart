import 'package:beering/public.dart';

class StepsCardAssetsModel {
  final String bgIcon;
  final String cardIcon;

  final String type;

  final KReportType pageType;

  final String value;

  StepsCardAssetsModel(
      {required this.bgIcon,
      required this.cardIcon,
      required this.type,
      required this.pageType,
      required this.value});
}
