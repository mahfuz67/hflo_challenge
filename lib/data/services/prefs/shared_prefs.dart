import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedService {
  Future<void> saveUserInput({required String userInput});
  Future<void> saveCycleInfo({required String  cycleInfo});
  String getUserInput();
  String getCycleInfo();
  bool userInputExist();
}

class SharedServiceImpl extends SharedService {
  SharedPreferences prefs;
  SharedServiceImpl({required this.prefs});

  @override
  String getUserInput() {
   return prefs.getString("USER_INPUT") ?? "";
  }

  @override
  Future<void> saveUserInput({required String userInput}) async{
    debugPrint(userInput);
    await prefs.setString("USER_INPUT", userInput);
  }

  @override
  String getCycleInfo() {
    return prefs.getString("CYCLE_INFO") ?? "";
  }

  @override
  Future<void> saveCycleInfo({required String cycleInfo}) async{
    debugPrint(cycleInfo);
    await prefs.setString("CYCLE_INFO", cycleInfo);
  }

  @override
  bool userInputExist() {
    return prefs.containsKey("USER_INPUT");
  }

}