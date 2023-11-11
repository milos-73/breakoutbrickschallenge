import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedValues {

  Future<int>getLastFinishedLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;
    print('LAST FINISHED LEVEL${lastFinishedLevel}');
    return lastFinishedLevel;
  }

  Future<void>setLastFinishedLevel(finishedLevel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastFinishedLevel',finishedLevel);
  }

  Future<void>setCurrentPlayedLevelNumber(int levelInProgressNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentPlayedLevelNumber', levelInProgressNumber);
  }

  Future<int>getCurrentPlayedLevelNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentLevel = prefs.getInt('currentPlayedLevelNumber') ?? 0;
    return currentLevel;
  }

  Future<void>saveLevelInProgressNumber(int currentPlayedLevelNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int level = prefs.getInt('currentPlayedLevelNumber') ?? 0;
    prefs.setInt('levelInProgress', level);
  }

  Future<int> getNumberOfStars(int level) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int numberOfStars = prefs.getInt('numberOfStars$level') ?? 0;
    return numberOfStars;
  }


}