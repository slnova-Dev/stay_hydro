import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stay_hydro/ads/ad_config.dart';
import 'package:stay_hydro/ads/ad_service.dart';

/// Anchored adaptive banner for the History screen only.
///
/// Shows nothing until an ad loads successfully (no large empty placeholder).
/// Disposes the [BannerAd] on failure and when the widget is removed.
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
      _loadBanner();
    }
  }

  Future<void> _loadBanner() async {
    if (_isLoading) return;
    _isLoading = true;
    final loadGeneration = ++_loadGeneration;

    await AdService.ensureInitialized();
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
          });
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
            debugPrint('HistoryBannerAd: failed to load: $error');
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
      } else {
        _isLoading = false;
      }
      if (kDebugMode) {
        debugPrint('HistoryBannerAd: load threw: $e');
      }
    }
  }

  @override
  void dispose() {
    _loadGeneration++;
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
