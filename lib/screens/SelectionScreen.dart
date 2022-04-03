import 'package:flutter/material.dart';
import 'package:ordertakingapp/screens/LoginScreen.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/Util.dart';
import 'package:ordertakingapp/widgets/button.dart';

import 'AdminMainPanel.dart';
import 'HomeScreen.dart';
import 'KitchenScreen.dart';

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    final logo =  Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("NAAN", style: TextStyle(color: Color(0xfffee2c1), fontSize: 50, fontWeight: FontWeight.w800),),
          Text("POINT", style: TextStyle(color: MyColors.mainColor, fontSize: 50, fontWeight: FontWeight.w800),),
        ],
      ),
    );

    final floorButton = Button(
      title: "Floor User",
    );

    final kitchenButton = Button(
      title: "Kitchen User",
    );

    final adminButton = Button(
      title: "Admin",
    );

    final appBar = AppBar(
      elevation: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: appBar,
        body: Center(
          child: Container(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: InkWell(
                      onTap: (){
                        gotoScreen("Floor User");
                      },
                      child: floorButton),
                ),
                SizedBox(height: 15.0),

                Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: InkWell(
                      onTap: (){
                        gotoScreen("Kitchen User");
                      },
                      child: kitchenButton),
                ),

                SizedBox(height: 15.0),

                Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: InkWell(
                      onTap: (){
                        gotoScreen("Admin");
                      },
                      child: adminButton),
                ),
              ],
            ),
          ),
        )
    );
  }

  gotoScreen(String type){
    if(type == "Admin"){
      Util.navigateView(_scaffoldKey.currentContext, new LoginScreen());

    } else if(type == "Floor User"){
      Util.navigateView(_scaffoldKey.currentContext, new HomeScreen());
    }else{
      Util.navigateView(_scaffoldKey.currentContext, new MainKitchenScreen());
    }

  }
}
