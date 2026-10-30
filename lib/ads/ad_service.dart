import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// One-shot Google Mobile Ads SDK initialization.
///
/// Safe to call multiple times; does not throw to callers. Failures are
/// logged and ads simply do not load.
class AdService {
  AdService._();

  static Future<void>? _initFuture;
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  /// Ensures [MobileAds.instance.initialize] runs at most once.
  static Future<void> ensureInitialized() {
    return _initFuture ??= _initialize();
  }

  static Future<void> _initialize() async {
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      if (kDebugMode) {
        debugPrint('AdService: Mobile Ads initialized');
      }
    } catch (e, st) {
      _initialized = false;
      if (kDebugMode) {
        debugPrint('AdService: Mobile Ads init failed: $e');
        debugPrint('$st');
      }
    }
  }
}
