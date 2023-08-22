import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi, sqrt;

import 'package:beering/public.dart';

class KRippleWave extends StatefulWidget {
  const KRippleWave({
    Key? key,
    this.color = Colors.teal,
    this.duration = const Duration(milliseconds: 1500),
    this.repeat = true,
    required this.child,
    this.childTween,
    required this.onCreate,
  }) : super(key: key);

  ///Color of the ripple
  final Color color;

  ///Widget inside the ripple
  final Widget child;

  /// Tween effect of the child widget
  final Tween<double>? childTween;

  ///Duration of the animation
  final Duration duration;

  ///Repeat the animation. True by default
  final bool repeat;

  final Function(AnimationController controller) onCreate;
  @override
  KRippleWaveState createState() => KRippleWaveState();
}

class KRippleWaveState extends State<KRippleWave>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    widget.onCreate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RipplePainter(
        _controller,
        color: widget.color,
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: <Color>[
                  widget.color,
                  Colors.transparent,
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScaleTransition(
                  scale: widget.childTween != null
                      ? widget.childTween!.animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: _CurveWave(),
                          ),
                        )
                      : Tween(begin: 0.9, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: _CurveWave(),
                          ),
                        ),
                  child: widget.child,
                ),
                RotationTransition(
                  turns: Tween<double>(begin: 0, end: 1).animate(_controller),
                  child: LoadAssetsImage(
                    "icons/searchdevice",
                    width: 229,
                    height: 229,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurveWave extends Curve {
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }

    return math.sin(t * math.pi);
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter(
    this.animation, {
    required this.color,
  }) : super(repaint: animation);
  final Color color;
  final Animation<double> animation;
  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color newColor = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = newColor;
    canvas.drawCircle(
      rect.center,
      radius,
      paint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(
      0.0,
      0.0,
      size.width,
      size.height,
    );
    for (int wave = 0; wave <= 5; wave++) {
      circle(canvas, rect, wave + animation.value);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) => true;
}
