import 'package:extended_image/extended_image.dart';
import 'package:focusring/const/constant.dart';

import '../../public.dart';

//load local image
class LoadAssetsImage extends StatelessWidget {
  LoadAssetsImage(
    this.name, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.scale,
  }) : super(key: key);

  final String name;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final double? scale;

  @override
  Widget build(BuildContext context) {
    var nameStr = "${assetsImages + name}@3x.png";
    return ExtendedImage.asset(
      nameStr,
      height: height,
      width: width,
      fit: fit,
      color: color,
      scale: scale,
    );
  }
}
