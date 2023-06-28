import 'package:flutter/cupertino.dart';
import '../../public.dart';

typedef NextButtonCallback = void Function();

class NextButton extends StatelessWidget {
  const NextButton(
      {Key? key,
      required this.onPressed,
      this.activeColor = const Color(0xFF000000),
      required this.title,
      this.enabled = true,
      this.height,
      this.borderRadius = 12,
      this.margin,
      this.padding,
      this.border,
      this.textStyle,
      this.inactiveColor,
      this.bgImg,
      this.width,
      this.gradient})
      : super(key: key);

  final NextButtonCallback onPressed;
  final Color? activeColor;
  final String title;
  final bool enabled;

  ///origin value
  final double? height;

  ///origin value
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final TextStyle? textStyle;
  final Color? inactiveColor;
  final Gradient? gradient;

  ///Constant.ASSETS_IMG + "icons/buttongradient.png",
  final String? bgImg;
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: padding,
      margin: margin,
      child: CupertinoButton(
        // behavior: HitTestBehavior.opaque,
        padding: EdgeInsets.zero,
        onPressed: () => _buttonOnPressed(context),
        child: Container(
          alignment: Alignment.center,
          height: height ?? 46.w,
          padding: padding,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            border: border,
            color: enabled ? activeColor : inactiveColor,
            image: bgImg == null
                ? null
                : DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(bgImg!),
                  ),
            gradient: gradient,
          ),
          child: Text(
            title,
            style: textStyle ?? Get.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  void _buttonOnPressed(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (enabled) {
      onPressed();
    }
  }
}
