import 'package:focusring/public.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import "package:syncfusion_flutter_charts/src/chart/chart_series/series_renderer_properties.dart";
import "package:syncfusion_flutter_charts/src/chart/chart_series/series.dart";

class CustomRangeColumnRenderer extends RangeColumnSeriesRenderer {
  CustomRangeColumnRenderer(
      // required this.averageValue,
      // required this.yAxisRenderer,
      );

  @override
  RangeColumnSegment createSegment() {
    final CustomRangeColumnSegment segment = CustomRangeColumnSegment();
    segment.seriesRenderer = this;
    return segment;
  }
}

class CustomRangeColumnSegment extends RangeColumnSegment {
  late RangeColumnSeriesRenderer seriesRenderer;
  @override
  void onPaint(Canvas canvas) {
    super.onPaint(canvas);

    final Paint paint = Paint()
      ..color = Colors.white // 平均线的颜色
      ..strokeWidth = 2;

    final double centerX = segmentRect.left + segmentRect.width / 2;
    final double centerY = segmentRect.top + segmentRect.height / 2;

    vmPrint(segmentRect);
    // 绘制平均线
    canvas.drawLine(
      Offset(segmentRect.left, centerY),
      Offset(segmentRect.right, centerY),
      paint,
    );

    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);

    // seriesRendererDetails.yAxisDetails.ca
  }
}

class CustomRangeColumnSeries<T, U> extends RangeColumnSeries<T, U> {
  CustomRangeColumnSeries({
    required List<T> dataSource,
    required ChartValueMapper<T, U> xValueMapper,
    required ChartValueMapper<T, int> lowValueMapper,
    required ChartValueMapper<T, int> highValueMapper,
    required ChartValueMapper<T, int> averageValueMapper,
  }) : super(
          dataSource: dataSource,
          xValueMapper: xValueMapper,
          lowValueMapper: lowValueMapper,
          highValueMapper: highValueMapper,
        );

  ChartSegment createSegment() {
    return NewCustomRangeColumnSegment();
  }
}

class NewCustomRangeColumnSegment extends RangeColumnSegment {
  @override
  void onPaint(Canvas canvas) {
    // TODO: implement onPaint
    super.onPaint(canvas);

    final Paint paint = Paint()
      ..color = Colors.white // 平均线的颜色
      ..strokeWidth = 2;

    final double centerX = segmentRect.left + segmentRect.width / 2;
    final double centerY = segmentRect.top + segmentRect.height / 2;

    vmPrint(segmentRect);
    // 绘制平均线
    canvas.drawLine(
      Offset(segmentRect.left, centerY),
      Offset(segmentRect.right, centerY),
      paint,
    );
  }
}
