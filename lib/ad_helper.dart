import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (kIsWeb) {
      return "";
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-4378644602106509/8502201468';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4378644602106509/2267702276';
    } else {
      return "";
    }
  }

  static String get interstitialAdUnitId {
    if (kIsWeb) {
      return "";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      return "";
    }
  }

  static String get rewardedAdUnitId {
    if (kIsWeb) {
      return "";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      return "";
    }
  }
}
