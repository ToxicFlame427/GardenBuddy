import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdView extends StatefulWidget {
  const BannerAdView(
      {super.key,
      required this.androidBannerId,
      required this.iOSBannerId,
      required this.isTest,
      required this.isShown,
      required this.bannerSize});

  final String androidBannerId;
  final String iOSBannerId;
  final bool isTest;
  final bool isShown;
  final AdSize bannerSize;

  @override
  State<StatefulWidget> createState() {
    return _BannerAdViewState();
  }
}

class _BannerAdViewState extends State<BannerAdView> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // Initially use test ad units
  String adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';

  /// Loads a banner ad.
  void loadAd() async {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: widget.bannerSize,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the ad is a test, if not use real ids
    if (!widget.isTest) {
      if (Platform.isAndroid) {
        adUnitId = widget.androidBannerId;
      } else {
        adUnitId = widget.iOSBannerId;
      }
    }
    // If else, the test ad units still persist

    // Make sure that the ad does not keep making requests if it doesnt have to
    if (!_isLoaded) {
      loadAd();
    }

    if (_bannerAd != null && _isLoaded && widget.isShown) {
      print("Ad loaded with id $adUnitId and testing is ${widget.isTest}");

      return Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      );
    }

    return SizedBox(
      height: 0,
      width: 0,
    );
  }
}
