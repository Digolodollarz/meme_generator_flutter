import 'package:firebase_admob/firebase_admob.dart';

class Ads {
  static const appId = "ca-app-pub-2093893395803299~3796425962";
  static const interstitialAdId = "ca-app-pub-2093893395803299/5454435648";

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://diggle.tech/news/',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

//  static final BannerAd myTestBanner = BannerAd(
//    adUnitId: BannerAd.testAdUnitId,
//    size: AdSize.smartBanner,
//    targetingInfo: targetingInfo,
//    listener: (MobileAdEvent event) {
//      print("BannerAd event is $event");
//    },
//  );

  static final BannerAd createBanner = BannerAd(
    adUnitId: 'ca-app-pub-2093893395803299/2439397679',
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  static final BannerAd homeBanner = BannerAd(
    adUnitId: 'ca-app-pub-2093893395803299/2630969368',
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  static final InterstitialAd createInterstitial = InterstitialAd(
    adUnitId: 'ca-app-pub-2093893395803299/5454435648',
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );

  static final InterstitialAd myTestInterstitial = InterstitialAd(
    adUnitId: InterstitialAd.testAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );
}
