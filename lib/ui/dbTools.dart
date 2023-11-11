
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:username_gen/username_gen.dart';

class DbTools {

  Future<bool?> checkUserName(String desiredUserName) async {
    bool? existingUser;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    await dbRef.child('leaderboard').orderByChild('userName').equalTo(
        desiredUserName).limitToFirst(1).once().then((value) =>
    existingUser = value.snapshot.exists);

    return existingUser;
  }

  Future<bool?> checkUserEmail(String userEmail) async {
    bool? existingEmail;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    await dbRef.child('leaderboard').orderByChild('email').equalTo(userEmail)
        .limitToFirst(1).once()
        .then((value) => existingEmail = value.snapshot.exists);

    return existingEmail;
  }

  Future<String?> checkUserNameKey(String keyID) async {
    String? publicUserName;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    await dbRef.child('leaderboard/$keyID/userName').once().then((value) =>
    publicUserName = value.snapshot.value.toString());

    return publicUserName ?? '';
  }

  Future<int?> checkTopTotalPoints(String keyID) async {
    int? topTotalPoints;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    await dbRef.child('leaderboard/$keyID/points').once().then((value) =>
    topTotalPoints = int.tryParse(value.snapshot.value.toString()));

    return topTotalPoints;
  }

  Future<int?> getLastFinishedLevel(String keyID) async {
    int? lastFinishedLevel;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    await dbRef.child('leaderboard/$keyID/lastFinishedLevel').once().then((value) =>
    lastFinishedLevel = int.tryParse(value.snapshot.value.toString()));

    return lastFinishedLevel ?? 0;
  }

  Future<int?> checkTotalStars(String keyID) async {
    int? totalStars;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    await dbRef.child('leaderboard/$keyID/stars').once().then((value) =>
    totalStars = int.tryParse(value.snapshot.value.toString()));

    return totalStars;
  }

  Future<String?> checkStarsPerLevel(String keyID) async {
    String? totalStars;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    await dbRef.child('leaderboard/$keyID/listOfStarsPerLevel').once().then((value) =>
    totalStars = value.snapshot.value.toString());

    return totalStars;
  }

  Future<String?> getAllLevelsStarsString(String keyID) async {
    String? allLevelsStarsString;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    var snapshot = await dbRef.child('leaderboard/$keyID/listOfStarsPerLevel')
        .once();
    if (snapshot.snapshot.value == null) {
      return 'error';
    } else {
      await dbRef.child('leaderboard/$keyID/listOfStarsPerLevel').once().then((
          value) => allLevelsStarsString = value.snapshot.value.toString());

      print('getAllLevelsStarsString(): ${allLevelsStarsString}');

      return allLevelsStarsString;
    }
  }

  Future<String?> getUserName(String keyID) async {
    String? userName;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    var snapshot = await dbRef.child('leaderboard/$keyID/userName').once();
    if (snapshot.snapshot.value == null) {
      String localUserProfileName = UsernameGen().generate();
      return localUserProfileName;
    } else {
      await dbRef.child('leaderboard/$keyID/userName').once().then((value) =>
      userName = value.snapshot.value.toString());
      return userName ?? '';
    }
  }
}