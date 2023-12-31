import 'package:hex/hex.dart';

class HEXUtil {
  static String encode(List<int> input) {
    try {
      return HEX.encode(input);
    } catch (e) {
      assert(false, e);
      return "";
    }
  }

  static List<int> decode(String encoded) {
    try {
      encoded = encoded.replaceFirst("0x", "");
      if (encoded.length == 1) {
        encoded = "0$encoded";
      }
      return HEX.decode(encoded);
    } catch (e) {
      assert(false, e);
      return [];
    }
  }
}
