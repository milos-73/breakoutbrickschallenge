import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:initial_project/services/saved_values.dart';
import '../forge2d_game_world.dart';
import '../services/ad_helper.dart';

class BackToMenuButton extends SpriteComponent with Tappable, HasGameRef<BrickBreakGame>{

 static const int maxFailedLoadAttempts = 3;

 SavedValues savedValues = SavedValues();
 InterstitialAd? _interstitialAd;
 int _interstitialLoadAttempts = 1;


 void _createInterstitialAd() {
  InterstitialAd.load(
   adUnitId: AdHelper.interstitialAdUnitId,
   request: AdRequest(),
   adLoadCallback: InterstitialAdLoadCallback(
    onAdLoaded: (InterstitialAd ad) {
     _interstitialAd = ad;
     _interstitialLoadAttempts = 0;
    },
    onAdFailedToLoad: (LoadAdError error) {
     _interstitialLoadAttempts += 1;
     _interstitialAd = null;
     if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
      _createInterstitialAd();
     }
    },
   ),
  );
 }

 Future<void> _showInterstitialAd() async {
  if (_interstitialAd != null) {
   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
     ad.dispose();
     _overlays();
     _createInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      ad.dispose();
      _overlays();
     _createInterstitialAd();
    },
   );
   await _interstitialAd!.show();
  }
 }

 Future<void> _overlays() async {

  savedValues.saveLevelInProgressNumber(gameRef.currentPlayedLevelNumber);

  if (gameRef.overlays.isActive('PreGame')){gameRef.overlays.remove('PreGame');}
  if (gameRef.overlays.isActive('LostLife')){gameRef.overlays.remove('LostLife');}
  if (gameRef.overlays.isActive('GamePausedMenuOverlay')){gameRef.overlays.remove('GamePausedMenuOverlay');}
  if (gameRef.overlays.isActive('ChallengeGameOverOverlay')){gameRef.overlays.remove('ChallengeGameOverOverlay');}
  if (gameRef.overlays.isActive('NextLevelChallengeModeOverlay')){gameRef.overlays.remove('NextLevelChallengeModeOverlay');}
  if (gameRef.overlays.isActive('WinGame')){gameRef.overlays.remove('WinGame');}
  if (gameRef.overlays.isActive('LostLife')){gameRef.overlays.remove('LostLife');}

  if(gameRef.gameMode == GameMode.challenge){gameRef.fallingPoints?.resetFallingPoints();}
  if(gameRef.gameMode == GameMode.levels){gameRef.fallingStars?.resetFallingStars();}

  gameRef.pauseEngine();
  gameRef.gameState = GameState.paused;

  gameRef.overlays.add('MainMenu');
}

 @override
 Future<void> onLoad() async {
  await super.onLoad();
  _createInterstitialAd();
  sprite = await gameRef.loadSprite('buttons/home_button2.png');
  position = Vector2(30 , 7.9);
  size = Vector2(4, 4);
  priority = 5;
 }

 @override
 bool onTapUp(TapUpInfo info) {
  print("tap up");
  return false;
 }

 @override
 bool onTapDown(TapDownInfo info) {

  if (game.audioSettings == AudioSettings.on)  {
   FlameAudio.play('button3.mp3');}

  _showInterstitialAd();

  info.handled = true;
  return true;
 }

 @override
 bool onTapCancel() {
  print("tap cancel");
  return false;
 }

}





