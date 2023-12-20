import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:initial_project/forge2d_game_world.dart';

import '../services/ad_helper.dart';

class BannerAdOverlay extends StatefulWidget {

  final BrickBreakGame? game;

  const BannerAdOverlay({super.key, this.game});

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
  @override
  State<BannerAdOverlay> createState() => _BannerAdOverlayState();
}


class _BannerAdOverlayState extends State<BannerAdOverlay> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null){
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: SizedBox(
            //width: widget.game!.size.x * 40,
            width: (widget.game?.camera.viewport.canvasSize?.x)!*0.95,
            height: (widget.game?.camera.viewport.canvasSize?.y)!/14,
            //height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      );
    } else { return SizedBox(); }

  }
  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();
    super.dispose();
  }

}
