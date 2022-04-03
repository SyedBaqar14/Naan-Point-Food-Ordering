import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPref {
  static Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool("isLogin");
    return (boolValue == null) ? false : boolValue;
  }

  static setLoginStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('isLogin', status);
  }

  static setMemberInfoStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('isMemberInfoAdded', status);
  }

  static Future<bool> getMemberInfoStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool("isMemberInfoAdded");
    return (boolValue == null) ? false : boolValue;
  }

  static setUserData(String jsonString) async {
    SharedPreferences shared_User = await SharedPreferences.getInstance();
    shared_User.setString('user', jsonString);
  }

  static Future<String> getUserData() async {
    SharedPreferences shared_User = await SharedPreferences.getInstance();
    return shared_User.getString('user');
  }

  static getSharedPrefInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static clearPreference() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}
