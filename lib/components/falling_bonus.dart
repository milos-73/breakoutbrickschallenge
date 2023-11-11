import 'dart:math';

import 'package:flame/components.dart';
import 'package:initial_project/components/bonus_cannon.dart';
import 'package:initial_project/components/bonus_fast.dart';
import 'package:initial_project/components/bonus_power_ball.dart';
import 'package:initial_project/components/bonus_slow.dart';
import 'package:initial_project/components/bonus_sticky_ball.dart';
import 'package:initial_project/forge2d_game_world.dart';
import 'package:flutter/material.dart';

import 'bonus_bullet.dart';

class FallingBonus extends Component with HasGameRef<BrickBreakGame> {

  FallingBonus() : super(priority: 3);

  late TimerComponent bonusTimer;
  int elapseTics = 0;
  late TimerComponent slowPeriod;
  late TimerComponent fastPeriod;
  late TimerComponent bulletsPeriod;
  late TimerComponent powerBallTimer;
  late TimerComponent stickyBallTimer;
  int count = 0;

//List zoznam = [Brick(size: null, position: null, spriteName: ''), Ball(position: null, radius: null)];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //print('FALLING BONUS on LOAD');
    bonusTimer = TimerComponent(period: 12, repeat: true, removeOnFinish: true, onTick: () {elapseTics += 1; getBonus();});
    //print('ELAPSE TIME: $elapseTics');
    add(bonusTimer);
  }

  @override
  Future<void> update(double dt) async {

      for (final child in [... children]){

        if (child is BonusStickyBall && child.destroy){
          for ( final fixture in [...child.body.fixtures]){
            child.body.destroyFixture(fixture);
          }
          gameRef.world.destroyBody(child.body);
          remove(child);
          //stickyBallTimer = TimerComponent(period: 5, repeat: false, removeOnFinish: true,onTick:() {gameRef.stickyBallBonus = 0; gameRef.stickyBallState = StickyBallState.off; gameRef.stickyBallReplacement();});
          //add(stickyBallTimer);
        }

        if (child is BonusStickyBall && child.bonus){
          for ( final fixture in [...child.body.fixtures]){
            child.body.destroyFixture(fixture);
          }
          gameRef.world.destroyBody(child.body);
          remove(child);
          stickyBallTimer = TimerComponent(period: 12, repeat: false, removeOnFinish: true,onTick:() {gameRef.stickyBallBonus = 0; gameRef.stickyBallReplacement();});
          add(stickyBallTimer);
        }


        if (child is BonusSlow && child.destroy){
            for ( final fixture in [...child.body.fixtures]){
              child.body.destroyFixture(fixture);
            }
            gameRef.world.destroyBody(child.body);
            remove(child);
            slowPeriod = TimerComponent(period: 8, repeat: false, removeOnFinish: true,onTick:() {gameRef.slowBonus = 0;});
            add(slowPeriod);
          }

      if (child is BonusFast && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
        fastPeriod = TimerComponent(period: 8, repeat: false, removeOnFinish: true,onTick:() {gameRef.fastBonus = 0;});
        add(fastPeriod);
      }

      if (child is BonusCannon && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }

      if (child is BonusBullets && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }

      if (child is BonusPowerBall && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
        powerBallTimer = TimerComponent(period: 3, repeat: false, removeOnFinish: true,onTick:() {gameRef.powerBallBonus = 0; gameRef.cannonBallStatus = 0; gameRef.ball.body.setBullet(false);});
        add(powerBallTimer);
      }
    }
    super.update(dt);
  }

  Future<void>getBonus()async {

    double vectorX = (Random().nextInt(30)+5).toDouble();
    double vectorY = (Random().nextInt(30)+10).toDouble();

    var indexNumber = Random().nextInt(6)+1;
    //var indexNumber = 1;
    switch (indexNumber) {
      case 1:
        BonusBullets bonus = BonusBullets(size: const Size(1.8,1.8), position: Vector2(vectorX, vectorY),);
        if(gameRef.gameState == GameState.running){add(bonus..priority = 3);}
        break;
      case 2:
      BonusFast bonus = BonusFast(size: const Size(1.8,1.8), position: Vector2(vectorX, vectorY),);
      if(gameRef.gameState == GameState.running){add(bonus..priority = 3);}
      break;
      case 3:
        BonusSlow bonus = BonusSlow(size: const Size(1.8,1.8), position: Vector2(vectorX, vectorY),);
        if(gameRef.gameState == GameState.running){add(bonus..priority = 3);}
        break;
      case 4:
        BonusCannon bonus = BonusCannon(size: const Size(1.8,1.8), position: Vector2(vectorX, vectorY),);
        if(gameRef.gameState == GameState.running){add(bonus..priority = 3);}
        break;
      case 5:
        BonusPowerBall bonus = BonusPowerBall(size: const Size(1.8,1.8), position: Vector2(vectorX, vectorY),);
        if(gameRef.gameState == GameState.running){add(bonus..priority = 3);}
        break;
      case 6:
        BonusStickyBall bonus = BonusStickyBall(size: const Size(1.8,1.8), position: Vector2(vectorX, vectorY),);
        if(gameRef.gameState == GameState.running){add(bonus..priority = 3);}
        break;
      default:
        break;
    }
  }

  Future<void> resetFallingBonus() async {

    bonusTimer.removeFromParent();
    //gameRef.gunState = GunState.off;
    gameRef.fastBonus = 0;
    gameRef.slowBonus = 0;
    gameRef.cannonBallStatus = 0;
    gameRef.powerBallBonus = 0;
    gameRef.countDown = 0;
    gameRef.countDown2 = 0;
    gameRef.countDown3 = 0;
    gameRef.ticks = 1;
    gameRef.stickyBallBonus = 0;

    if(gameRef.gunState == GunState.on || gameRef.gunState == GunState.inProgress){print('RESETING BONUS from resetting falling bonus'); gameRef.gun?.removeFromParent(); gameRef.bullets?.resetAllBullets(); gameRef.paddle.resetGun(); gameRef.gunState = GunState.off;}
    if(gameRef.gunState == GunState.through || gameRef.gunState == GunState.inProgress){ gameRef.cannonBall?.resetCannonBall();gameRef.gunState = GunState.off;}

    // gameRef.gun.removeFromParent();
    // gameRef.bullet.removeFromParent();
    // gameRef.bulletsInterval.removeFromParent();
    // gameRef.interval.removeFromParent();

    removeAll(children);
    elapseTics = 0;
    bonusTimer = TimerComponent(period: 12,removeOnFinish: true, repeat: true,onTick: (){elapseTics += 1;getBonus();});
    add(bonusTimer);
  }

}