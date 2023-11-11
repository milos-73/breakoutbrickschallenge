import 'dart:convert';

import 'package:flutter/services.dart';

import 'brick_wall_json_model.dart';

class WallBricks {
  Future<BrickList> readBrickListFromJson(int level) async{
    final String response = await rootBundle.loadString('assets/jsonwalls/wall$level.json');
    print ('JSON DATA: ${response}');
    return BrickList.fromJson(json.decode(response));
  }

}