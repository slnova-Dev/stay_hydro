import 'package:flutter/foundation.dart';

/// AdMob IDs and Phase 1 test/production selection.
///
/// Phase 1 uses Google's official Android test banner unit only.
/// Production History banner ID is documented here for a later release
/// switch — it is not requested while [useTestAds] is true or in debug.
class AdConfig {
  AdConfig._();

  /// StayHydro AdMob Android App ID (manifest metadata; not an ad unit).
  static const String androidAppId = 'ca-app-pub-3461639948565250~7754560377';

  /// Production History banner unit — DO NOT use while [useTestAds] is true.
  static const String historyBannerProductionUnitId =
      'ca-app-pub-3461639948565250/6362637408';

  /// Google's official Android test banner unit.
  static const String androidTestBannerUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  /// PHASE 1 SAFETY SWITCH: keep `true` until an intentional release config.
  /// When true, production ad units are never requested.
  static const bool useTestAds = false;

  /// Ad unit used for the History-screen banner.
  static String get historyBannerAdUnitId {
    if (useTestAds || kDebugMode) {
      return androidTestBannerUnitId;
    }
    return historyBannerProductionUnitId;
  }
}
