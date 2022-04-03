import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordertakingapp/screens/AddMenuScreen.dart';
import 'package:ordertakingapp/screens/AllMenuList.dart';
import 'package:ordertakingapp/screens/HomeScreen.dart';
import 'package:ordertakingapp/screens/KitchenScreen.dart';
import 'package:ordertakingapp/screens/LoginScreen.dart';
import 'package:ordertakingapp/screens/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
