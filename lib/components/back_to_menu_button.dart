import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:initial_project/services/saved_values.dart';
import '../forge2d_game_world.dart';

class BackToMenuButton extends SpriteComponent with Tappable, HasGameRef<BrickBreakGame>{

 SavedValues savedValues = SavedValues();

 @override
 Future<void> onLoad() async {
  await super.onLoad();
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

  print('GAME STATE: ${gameRef.gameState}');
  if (game.audioSettings == AudioSettings.on)  {
  FlameAudio.play('button3.mp3');}
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

  info.handled = true;
  return true;
 }

 @override
 bool onTapCancel() {
  print("tap cancel");
  return false;
 }
}



