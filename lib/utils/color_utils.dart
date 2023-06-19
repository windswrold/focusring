import '../public.dart';

class ColorUtils {
  static Color rgba(int r, int g, int b, double a) {
    return Color.fromARGB((a * 255).toInt(), r, g, b);
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
