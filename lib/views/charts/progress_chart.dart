import '../../public.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart(
      {Key? key,
      required this.progressValue,
      required this.textColor,
      required this.rangePointerColor})
      : super(key: key);

  final double progressValue;

  final Color? textColor;

  final Color? rangePointerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.2,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progressValue * 100,
                width: 0.2,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 75,
                animationType: AnimationType.linear,
                color: rangePointerColor,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                positionFactor: 0.1,
                widget: Text(
                  '${(progressValue * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ]),
      ]),
    );
  }
}
