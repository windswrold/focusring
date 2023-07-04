import 'package:flutter/material.dart';
import 'package:focusring/views/dialog_widgets/controllers/dialog_modify_goals_controller.dart';
import 'package:focusring/views/dialog_widgets/dialog_header.dart';

import '../../../public.dart';

class DialogModifyGoalsPage extends GetView<DialogModifyGoalsController> {
  Widget _getHeader() {
    return DialogDefaultHeader(
      title: controller.type.getDisplayName(isGoals: true),
      onCancel: controller.onCancel,
      onConfirm: controller.onOk,
    );
  }

  Widget _getSlider(BuildContext c) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(c).copyWith(
            trackHeight: 12,
            thumbColor: ColorUtils.fromHex("#FF09C2EE"), // 设置滑块中心颜色为红色
            thumbShape: _CustomThumbShape(),
            overlayColor: Colors.white,
          ),
          child: Obx(
            () => Slider(
              value: controller.currentValue.value.toDouble(),
              min: controller.minValue.value.toDouble(),
              max: controller.maxValue.value.toDouble(),
              activeColor: ColorUtils.fromHex("#FF09C2EE"),
              inactiveColor: ColorUtils.fromHex("#FF000000"),
              thumbColor: Colors.white,
              onChanged: (a) {
                controller.onChanged(a);
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.minValue.value.toString(),
                style: Get.textTheme.displayLarge,
              ),
              Text(
                controller.maxValue.value.toString(),
                style: Get.textTheme.displayLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.w,
      color: ColorUtils.fromHex("#FF232126"),
      child: Column(
        children: [
          _getHeader(),
          Obx(
            () => Container(
              margin: EdgeInsets.only(top: 10.w, bottom: 20.w),
              child: Text(
                controller.currentStr.value,
                style: Get.textTheme.bodyLarge,
              ),
            ),
          ),
          _getSlider(context),
        ],
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(12); // 设置滑块半径大小
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    // TODO: implement paint

    final canvas = context.canvas;
    final radius = 8.0;

    // 绘制蓝色圆形背景
    final circlePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 1.8, circlePaint);

    // 绘制红色圆形
    final thumbPaint = Paint()..color = ColorUtils.fromHex("#FF09C2EE");
    canvas.drawCircle(center, radius, thumbPaint);
  }
}
