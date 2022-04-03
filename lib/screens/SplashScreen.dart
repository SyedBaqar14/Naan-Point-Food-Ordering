import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ordertakingapp/screens/AdminMainPanel.dart';
import 'package:ordertakingapp/screens/SelectionScreen.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/LoginPref.dart';
import 'package:ordertakingapp/util/Util.dart';
import 'package:permission_handler/permission_handler.dart';

import 'HomeScreen.dart';
import 'KitchenScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage(){
    Future<bool> status = LoginPref.getLoginStatus();
    status.then((value) {
      if(value){
        LoginPref.getUserData().then((type) {
          if (type == "Admin") {
            Util.pushAndRemoveUntil(_scaffoldKey.currentContext, new AdminMainPanelScreen());
          } else{
            Util.pushAndRemoveUntil(_scaffoldKey.currentContext, SelectionScreen());
          }
        });
      }else{
        Util.pushAndRemoveUntil(_scaffoldKey.currentContext, SelectionScreen());
      }

    }).catchError((e) {
      print(e);
      // Util.navigateViewWithPop(context, LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
    );


    final logo =  Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("NAAN", style: TextStyle(color: Color(0xfffee2c1), fontSize: 50, fontWeight: FontWeight.w800),),
          Text("POINT", style: TextStyle(color: MyColors.mainColor, fontSize: 50, fontWeight: FontWeight.w800),),
        ],
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SafeArea(
        child: Center(child: logo),
      ),
    );
  }

  void _requestPerms() async {
    Map<Permission, PermissionStatus> statuses = await
    [
      Permission.storage,
    ].request();
  }

  @override
  void initState() {
    startTime();
    _requestPerms();
    super.initState();
  }
}

