import 'package:beering/public.dart';
import 'package:beering/views/charts/home_card/model/home_card_x.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomRangeColumnRenderer extends RangeColumnSeriesRenderer {
  CustomRangeColumnRenderer(this.dataSource);

  final List<KChartCellData> dataSource;

  @override
  RangeColumnSegment createSegment() {
    final CustomRangeColumnSegment segment = CustomRangeColumnSegment();
    segment.dataSource = dataSource;
    return segment;
  }
}

class CustomRangeColumnSegment extends RangeColumnSegment {
  late RangeColumnSeriesRenderer seriesRenderer;

  late final List<KChartCellData> dataSource;

  @override
  void onPaint(Canvas canvas) {
    super.onPaint(canvas);

    final cellData = dataSource[currentSegmentIndex!];
    final height = segmentRect.height;
    final avge = cellData.averageNum;
    final low = cellData.yor_low;
    final high = cellData.high;
    final offset = height / (low.abs() + high.abs());
    final avgeHeight = ((avge - low).abs()) * offset + segmentRect.top;
    final Paint paint = Paint()
      ..color = Colors.white // 平均线的颜色
      ..strokeWidth = 2;
    // 绘制平均线
    canvas.drawLine(
      Offset(segmentRect.left, avgeHeight),
      Offset(segmentRect.right, avgeHeight),
      paint,
    );
  }
}
