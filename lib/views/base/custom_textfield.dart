// import 'package:flutter/services.dart';
// import '../../public.dart';

// class CustomTextField extends StatefulWidget {
//   CustomTextField({
//     Key? key,
//     this.margin,
//     this.maxLines = 1,
//     this.obscureText = false,
//     this.onSubmitted,
//     required this.controller,
//     this.decoration,
//     this.style,
//     this.maxLength,
//     this.onChange,
//     this.textAlign,
//     this.enabled = true,
//     this.keyboardType = TextInputType.text,
//     this.inputFormatters,
//     this.autofocus = false,
//     this.returnKeyType = TextInputAction.done,
//     this.height,
//   }) : super(key: key);

//   final EdgeInsetsGeometry? margin;
//   final TextEditingController? controller;
//   final int maxLines;
//   final bool obscureText;
//   final ValueChanged<String>? onSubmitted;
//   final InputDecoration? decoration;
//   final TextStyle? style;
//   final int? maxLength;
//   final TextAlign? textAlign;
//   final ValueChanged<String>? onChange;
//   final bool enabled;
//   final TextInputType keyboardType;
//   final TextInputAction returnKeyType;
//   final List<TextInputFormatter>? inputFormatters;
//   final bool autofocus;
//   final double? height;

//   static TextInputFormatter decimalInputFormatter(int decimals) {
//     late String amount;
//     if (decimals == 0) {
//       amount = '^[0-9]{0,}\$';
//     } else {
//       amount = '^[0-9]{0,}(\\.[0-9]{0,$decimals})?\$';
//     }
//     return RegExInputFormatter.withRegex(amount);
//   }

//   static InputDecoration getUnderLineDecoration({
//     required BuildContext context,
//     String? hintText,
//     TextStyle? hintStyle,
//     String? helperText,
//     TextStyle? helperStyle,
//     Widget? prefixIcon,
//     Widget? suffixIcon,
//     BoxConstraints suffixIconConstraints =
//         const BoxConstraints(maxWidth: 100, maxHeight: double.infinity),
//     BoxConstraints prefixIconConstraints =
//         const BoxConstraints(minWidth: 80, maxHeight: double.infinity),
//     double underLineWidth = 1,
//     Color? fillColor,
//     EdgeInsetsGeometry contentPadding = EdgeInsets.zero,
//   }) {
//     return InputDecoration(
//       prefixIcon: prefixIcon,
//       suffixIcon: suffixIcon,
//       suffixIconConstraints: suffixIconConstraints,
//       prefixIconConstraints: prefixIconConstraints,
//       enabledBorder: UnderlineInputBorder(
//         borderSide: BorderSide(
//             width: underLineWidth, color: ColorUtils.rgba(151, 151, 178, 0.15)),
//       ),
//       focusedBorder: UnderlineInputBorder(
//         borderSide: BorderSide(
//             width: underLineWidth, color: ColorUtils.rgba(151, 151, 178, 0.15)),
//       ),
//       counterText: '',
//       hintText: hintText,
//       hintStyle: ThemeUtils.getHintTextStyle(context.isDark),
//       helperText: helperText,
//       helperStyle: helperStyle,
//       helperMaxLines: 5,
//       fillColor: fillColor ?? ThemeUtils.getFillColor(context.isDark),
//       filled: true,
//       contentPadding: contentPadding,
//     );
//   }

//   static InputDecoration getBorderLineDecoration({
//     required BuildContext context,
//     Color borderColor: Colors.transparent,
//     String? hintText,
//     String? helperText,
//     TextStyle? helperStyle,
//     EdgeInsetsGeometry? contentPadding,
//     double borderRadius = 8,
//     Widget? prefixIcon,
//     Widget? suffixIcon,
//     String? counterText,
//     TextStyle? hintTextStyle,
//     TextStyle? counterStyle,
//     BoxConstraints suffixIconConstraints =
//         const BoxConstraints(maxWidth: 100, maxHeight: double.infinity),
//     BoxConstraints prefixIconConstraints =
//         const BoxConstraints(minWidth: 80, maxHeight: double.infinity),
//     Color? fillColor,
//   }) {
//     return InputDecoration(
//       prefixIcon: prefixIcon,
//       suffixIcon: suffixIcon,
//       suffixIconConstraints: suffixIconConstraints,
//       prefixIconConstraints: prefixIconConstraints,
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(borderRadius),
//         borderSide: BorderSide(color: borderColor),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(borderRadius),
//         borderSide: BorderSide(color: borderColor),
//       ),
//       disabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(borderRadius),
//         borderSide: BorderSide(color: borderColor),
//       ),
//       hintText: hintText,
//       hintStyle: hintTextStyle ??
//           TextStyle(
//               fontSize: 16.width375,
//               fontWeight: FontWeight.w500,
//               color: UIConstant.grayTextColor),
//       helperText: helperText,
//       helperStyle: helperStyle,
//       helperMaxLines: 5,
//       fillColor: fillColor ?? Colors.white,
//       filled: true,
//       contentPadding:
//           contentPadding ?? EdgeInsets.fromLTRB(18.width375, 0, 18.width375, 0),
//       counterText: counterText,
//       counterStyle: counterStyle,
//     );
//   }

//   static Widget getInputTextField(
//     BuildContext context, {
//     TextEditingController? controller,
//     String? hintText,
//     String? titleText,
//     String? helpText,
//     bool obscureText = false, //whether to hide characters
//     EdgeInsetsGeometry padding = EdgeInsets.zero,
//     int? maxLength,
//     int maxLines = 1,
//     EdgeInsetsGeometry contentPadding = const EdgeInsets.fromLTRB(0, 0, 0, 0),

//     ///display icon
//     bool isPasswordText = false,
//     bool isScanText = false,
//     VoidCallback? onPressBack,
//   }) {
//     return Padding(
//         padding: padding,
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(children: [
//                 Container(
//                   margin: EdgeInsets.only(right: isScanText ? 40 : 0),
//                   child: CustomTextField(
//                     controller: controller,
//                     obscureText: obscureText,
//                     maxLength: maxLength,
//                     maxLines: maxLines,
//                     style: ThemeUtils.getTextFieldStyle(context.isDark),
//                     decoration: CustomTextField.getUnderLineDecoration(
//                       hintText: hintText,
//                       contentPadding: contentPadding,
//                       context: context,
//                     ),
//                   ),
//                 ),
//                 isPasswordText
//                     ? Positioned(
//                         right: OffsetWidget.setSc(0),
//                         child: IconButton(
//                             highlightColor: Colors.transparent,
//                             splashColor: Colors.transparent,
//                             icon: Image.asset(
//                               obscureText
//                                   ? ThemeUtils.getCloseEyes(context)
//                                   : ThemeUtils.getOpenEyes(context),
//                               width: OffsetWidget.setSc(16),
//                               height: OffsetWidget.setSc(16),
//                               color: themedTextColor,
//                             ),
//                             onPressed: onPressBack),
//                       )
//                     : Container(),
//                 isScanText
//                     ? Positioned(
//                         right: OffsetWidget.setSc(0),
//                         child: IconButton(
//                             highlightColor: Colors.transparent,
//                             splashColor: Colors.transparent,
//                             icon: Image.asset(
//                               obscureText
//                                   ? ThemeUtils.getIconScan(context)
//                                   : ThemeUtils.getIconScan(context),
//                               width: 24,
//                               height: 24,
//                             ),
//                             onPressed: onPressBack),
//                       )
//                     : Container(),
//               ]),
//               OffsetWidget.vGap(10),
//               Visibility(
//                 visible: helpText != null,
//                 child: Text(
//                   helpText ??= '',
//                   style: TextStyle(
//                     color:
//                         ThemeUtils.getTextHelpColor(context).withOpacity(0.6),
//                     fontSize: OffsetWidget.setSp(12),
//                     fontWeight: FontWightHelper.regular,
//                   ),
//                 ),
//               )
//             ]));
//   }

//   @override
//   _CustomTextFieldState createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   @override
//   Widget build(BuildContext context) {
//     final EdgeInsetsGeometry? margin = widget.margin;
//     final TextEditingController? controller = widget.controller;
//     int maxLines = widget.maxLines;
//     final obscureText = widget.obscureText;
//     final onSubmitted = widget.onSubmitted;
//     return Container(
//       margin: widget.margin,
//       height: widget.height,
//       decoration:
//           BoxDecoration(borderRadius: BorderRadius.circular(16.width375)),
//       alignment: Alignment.center,
//       child: TextField(
//         autofocus: widget.autofocus,
//         controller: widget.controller,
//         maxLines: widget.maxLines,
//         obscureText: widget.obscureText,
//         textAlign: widget.textAlign ?? TextAlign.left,
//         onSubmitted: widget.onSubmitted,
//         textInputAction: widget.returnKeyType,
//         style: widget.style ??
//             TextStyle(
//                 fontSize: 16.width375,
//                 fontWeight: FontWeight.w500,
//                 color: UIConstant.textColor),
//         maxLength: widget.maxLength,
//         onChanged: widget.onChange,
//         enabled: widget.enabled,
//         keyboardType: widget.keyboardType,
//         inputFormatters: widget.inputFormatters,
//         decoration: widget.decoration,
//       ),
//     );
//   }
// }
