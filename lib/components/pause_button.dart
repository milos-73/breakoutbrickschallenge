import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:initial_project/services/saved_values.dart';
import '../forge2d_game_world.dart';

class PauseButton extends SpriteComponent with Tappable, HasGameRef<BrickBreakGame>{

  SavedValues savedValues = SavedValues();


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('buttons/pause_button2.png');
    position = Vector2(26 , 7.9);
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

       if(gameRef.gameState == GameState.lost || gameRef.gameState == GameState.challengeLost){return true;}
       else{
       if(gameRef.gameState == GameState.ready){gameRef.pauseButtonState = PauseButtonState.startGame;}
      if(gameRef.gameState == GameState.restart){gameRef.pauseButtonState = PauseButtonState.ballLost;}

      if (game.audioSettings == AudioSettings.on)  {
      FlameAudio.play('button3.mp3');}
      gameRef.gameState = GameState.paused;
      gameRef.pauseEngine();
      if(game.overlays.isActive('PreGame')){game.overlays.remove('PreGame');game.gameState = GameState.preGamePaused;}
      if(game.overlays.isActive('PostGame')){game.overlays.remove('PostGame');}
      if(game.overlays.isActive('WinGame')){game.overlays.remove('WinGame');}
      if(game.overlays.isActive('LostLife')){game.overlays.remove('LostLife');}

      if(game.overlays.isActive('NextLevelChallengeModeOverlay')){game.overlays.remove('NextLevelChallengeModeOverlay');}
      if(game.overlays.isActive('ChallengeGameOverOverlay')){game.overlays.remove('ChallengeGameOverOverlay');}
      gameRef.overlays.add('GamePausedMenuOverlay');
      info.handled = true;
      return true;}

  }

  @override
  bool onTapCancel() {
    print("tap cancel");
    return false;
  }
}



