import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stay_hydro/ads/ad_config.dart';
import 'package:stay_hydro/ads/ad_service.dart';

/// Anchored adaptive banner for the History screen only.
///
/// Shows nothing until an ad loads successfully (no large empty placeholder).
/// Disposes the [BannerAd] on failure and when the widget is removed.
/// Implements a bounded, conservative retry policy for transient failures.
class HistoryBannerAd extends StatefulWidget {
  const HistoryBannerAd({super.key});

  @override
  State<HistoryBannerAd> createState() => _HistoryBannerAdState();
}

class _HistoryBannerAdState extends State<HistoryBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;
  int _loadGeneration = 0;
  Orientation? _lastOrientation;
  double? _lastWidthDp;

  // Bounded retry controls
  Timer? _retryTimer;
  int _retryAttempt = 0;
  static const int _maxRetryAttempts = 2;
  static const Duration _baseRetryDelay = Duration(seconds: 30);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final media = MediaQuery.of(context);
    final orientation = media.orientation;
    final widthDp = media.size.width;
    if (_bannerAd == null ||
        orientation != _lastOrientation ||
        widthDp != _lastWidthDp) {
      _lastOrientation = orientation;
      _lastWidthDp = widthDp;
      _cancelRetry();
      _loadBanner();
    }
  }

  void _cancelRetry() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  Future<void> _loadBanner() async {
    if (_isLoading) return;
    _isLoading = true;
    final loadGeneration = ++_loadGeneration;

    try {
      await AdService.ensureInitialized();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('HistoryBannerAd: AdService init failed: $e');
      }
      if (!mounted || loadGeneration != _loadGeneration) {
        _isLoading = false;
        return;
      }
      setState(() {
        _isLoading = false;
      });
      _scheduleRetry();
      return;
    }

    if (!mounted || loadGeneration != _loadGeneration) {
      _isLoading = false;
      return;
    }

    final width = MediaQuery.sizeOf(context).width.truncate();
    if (width <= 0) {
      _isLoading = false;
      return;
    }

    AdSize? size;
    try {
      size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('HistoryBannerAd: adaptive size failed: $e');
      }
    }

    size ??= AdSize.banner;

    if (!mounted || loadGeneration != _loadGeneration) {
      _isLoading = false;
      return;
    }

    final previous = _bannerAd;
    _bannerAd = null;
    _isLoaded = false;
    previous?.dispose();

    late final BannerAd banner;
    banner = BannerAd(
      adUnitId: AdConfig.historyBannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted || loadGeneration != _loadGeneration) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
            _isLoading = false;
            _retryAttempt = 0; // Reset retry count upon success
          });
          _cancelRetry();
          if (kDebugMode) {
            debugPrint(
              'HistoryBannerAd: loaded (${AdConfig.historyBannerAdUnitId})',
            );
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (loadGeneration != _loadGeneration) return;
          if (!mounted) {
            _isLoading = false;
            return;
          }
          setState(() {
            _bannerAd = null;
            _isLoaded = false;
            _isLoading = false;
          });
          if (kDebugMode) {
            debugPrint(
              'HistoryBannerAd: failed to load (code: ${error.code}, domain: ${error.domain}): ${error.message}',
            );
          }

          // Do not retry permanent configuration errors (code 1 = invalid request)
          if (error.code != 1) {
            _scheduleRetry();
          }
        },
      ),
    );

    try {
      await banner.load();
    } catch (e) {
      banner.dispose();
      if (loadGeneration != _loadGeneration) return;
      if (mounted) {
        setState(() {
          _bannerAd = null;
          _isLoaded = false;
          _isLoading = false;
        });
        _scheduleRetry();
      } else {
        _isLoading = false;
      }
      if (kDebugMode) {
        debugPrint('HistoryBannerAd: load threw: $e');
      }
    }
  }

  void _scheduleRetry() {
    _cancelRetry();
    if (_retryAttempt >= _maxRetryAttempts || !mounted) {
      if (kDebugMode) {
        debugPrint(
          'HistoryBannerAd: reached max retry limit ($_maxRetryAttempts). Stopping.',
        );
      }
      return;
    }

    _retryAttempt++;
    // First retry: 30s, Second retry: 60s
    final delay = _baseRetryDelay * _retryAttempt;
    if (kDebugMode) {
      debugPrint(
        'HistoryBannerAd: scheduling retry #$_retryAttempt in ${delay.inSeconds}s',
      );
    }

    _retryTimer = Timer(delay, () {
      if (!mounted) return;
      _loadBanner();
    });
  }

  @override
  void dispose() {
    _loadGeneration++;
    _cancelRetry();
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    if (!_isLoaded || ad == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
