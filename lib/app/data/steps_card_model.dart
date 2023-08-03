import 'package:focusring/public.dart';

class StepsCardModel {
  final String bgIcon;
  final String cardIcon;

  final String type;

  final KReportType pageType;

  final String value;

  StepsCardModel(
      {required this.bgIcon,
      required this.cardIcon,
      required this.type,
      required this.pageType,
      required this.value});
}
