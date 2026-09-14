import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdManager instance = AdManager._internal();
  AdManager._internal();

  AppOpenAd? _appOpenAd;
  bool _isShowingAppOpenAd = false;
  DateTime? _lastAppOpenShownTime;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  int _actionCounter = 0;

  RewardedAd? _rewardedAd;
  bool _isRewardedLoading = false;

  // Test Ad Unit IDs for Android / iOS
  static const String testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testAppOpenId = 'ca-app-pub-3940256099942544/9257399448';
  static const String testRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  // Production Ad Unit IDs
  static const String prodBannerId = 'ca-app-pub-2103558986527802/4916938220';
  static const String prodInterstitialId = 'ca-app-pub-2103558986527802/2412484808';
  static const String prodAppOpenId = 'ca-app-pub-2103558986527802/7351529879';
  static const String prodRewardedId = 'ca-app-pub-2103558986527802/1099403138';

  String get bannerAdUnitId => kDebugMode ? testBannerId : prodBannerId;
  String get interstitialAdUnitId => kDebugMode ? testInterstitialId : prodInterstitialId;
  String get appOpenAdUnitId => kDebugMode ? testAppOpenId : prodAppOpenId;
  String get rewardedAdUnitId => kDebugMode ? testRewardedId : prodRewardedId;

  Future<void> init() async {
    try {
      await MobileAds.instance.initialize();
      loadAppOpenAd();
      loadInterstitialAd();
      loadRewardedAd();
    } catch (e) {
      debugPrint('AdManager init error: $e');
    }
  }

  // ==================== APP OPEN AD ====================
  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          _appOpenAd = null;
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable() {
    if (_isShowingAppOpenAd || _appOpenAd == null) {
      loadAppOpenAd();
      return;
    }

    // Cooldown: Ít nhất 4 giờ giữa các lần hiển thị App Open Ad
    if (_lastAppOpenShownTime != null) {
      final difference = DateTime.now().difference(_lastAppOpenShownTime!);
      if (difference.inHours < 4) {
        return;
      }
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAppOpenAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAppOpenAd = false;
        _lastAppOpenShownTime = DateTime.now();
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }

  // ==================== INTERSTITIAL AD ====================
  void loadInterstitialAd() {
    if (_isInterstitialLoading) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
          _interstitialAd = null;
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  /// Hiển thị Interstitial Ad khi hoàn thành hành động (Có kiểm soát tần suất)
  void showInterstitialAd({bool force = false}) {
    _actionCounter++;
    // Tần suất: Hiển thị sau mỗi 4 hành động hoặc khi force = true
    if (!force && (_actionCounter % 4 != 0)) {
      return;
    }

    if (_interstitialAd == null) {
      loadInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
    );

    _interstitialAd!.show();
  }

  // ==================== REWARDED AD ====================
  void loadRewardedAd() {
    if (_isRewardedLoading) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _isRewardedLoading = false;
        },
      ),
    );
  }

  void showRewardedAd({required Function onUserEarnedReward}) {
    if (_rewardedAd == null) {
      loadRewardedAd();
      onUserEarnedReward(); // Fallback if ad is unavailable
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onUserEarnedReward();
      },
    );
  }
}
