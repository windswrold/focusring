import 'package:json_cache/json_cache.dart';
import 'package:localstorage/localstorage.dart';

class VMCacheManager {
  static final JsonCacheLocalStorage _jsonCache =
      JsonCacheLocalStorage(LocalStorage("some_key"));

  static Future<void> refresh(String queryKey, dynamic value) {
    if (queryKey.isEmpty) {
      throw "queryKey not be null";
    }
    if (value == null || value is Map == false) {
      return Future.value();
    }

    return _jsonCache.refresh(queryKey, value);
  }

  static Future<Map<String, dynamic>?> query(String queryKey) {
    if (queryKey.isEmpty) {
      throw "queryKey not be null";
    }
    return _jsonCache.value(queryKey);
  }

  static Future<void> remove(String queryKey) {
    if (queryKey.isEmpty) {
      throw "queryKey not be null";
    }
    return _jsonCache.remove(queryKey);
  }

  static Future<void> clear() {
    return _jsonCache.clear();
  }
}
