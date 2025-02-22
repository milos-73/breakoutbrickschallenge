import 'package:shared_preferences/shared_preferences.dart';

class SavedValues {

  Future<int> getLastFinishedLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;
    return lastFinishedLevel;
  }

  Future<void> setLastFinishedLevel(finishedLevel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastFinishedLevel', finishedLevel);
  }

  Future<void> setCurrentPlayedLevelNumber(int levelInProgressNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentPlayedLevelNumber', levelInProgressNumber);
  }

  Future<int> getCurrentPlayedLevelNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentLevel = prefs.getInt('currentPlayedLevelNumber') ?? 0;
    return currentLevel;
  }

  Future<void> saveLevelInProgressNumber(int currentPlayedLevelNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int level = prefs.getInt('currentPlayedLevelNumber') ?? 0;
    prefs.setInt('levelInProgress', level);
  }

  Future<int> getNumberOfStars(int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int numberOfStars = prefs.getInt('numberOfStars$level') ?? 0;
    return numberOfStars;
  }

  Future<int> getTotalGamePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalGamePoints = prefs.getInt('totalGamePoints') ?? 0;
    return totalGamePoints;
  }

  Future<int> getFiveStarsLevels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int fiveStarsLevels = 0;
    for (String key in prefs.getKeys()) {
      if (key.startsWith('numberOfStars')) {
        int? numOfStars = prefs.getInt(key) ?? 0;
        if (numOfStars == 5){fiveStarsLevels++;}

       }
    }
    return fiveStarsLevels;
  }

  Future<int> getTotalStars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalStars = prefs.getInt('totalStars') ?? 0;
    return totalStars;
  }

  Future<int> getFinishedChallengeLevels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int challengeLevels = prefs.getInt('challengeLevels') ?? 0;
    return challengeLevels;
  }
}
