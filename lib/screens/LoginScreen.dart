import 'package:flutter/material.dart';
import 'package:ordertakingapp/screens/HomeScreen.dart';
import 'package:ordertakingapp/screens/KitchenScreen.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/LoginPref.dart';
import 'package:ordertakingapp/util/ToastUtil.dart';
import 'package:ordertakingapp/util/Util.dart';
import 'package:ordertakingapp/widgets/button.dart';

import 'AdminMainPanel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isInternetAvailable = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //D56375

  bool floorSelected = false;
  bool kitchenSelected = false;
  bool adminSelected = false;

  String selectedUser = "Select User";

  List<String> emailList = [
    "Admin",
  ];

  List<String> passwordList = [
    "admin",
  ];

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

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

    final email = Container(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      width: double.maxFinite,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: MyColors.mainColor),
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.person, color: Colors.grey,),

            SizedBox(width: 10.0,),

            Text(
              "Admin",
              style: TextStyle(
                fontSize: 15.0
              ),
            ),
          ],
        ),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: decoration("Password", Icons.lock),
    );

    final loginButton = Button(
      title: "Log In",
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
                child: email,
              ),
              SizedBox(height: 15.0),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: password,
              ),
              SizedBox(height: 24.0),
              GestureDetector(
                onTap: () {
                  String userName = emailController.text.toString();
                  String password = passwordController.text.toString();

                  if(password.isEmpty){
                    ToastUtil.showToast(context, "Must enter password");
                    return;
                  }

                  if(passwordList[0] == password){
                    ToastUtil.showToast(context, "Login Successful");

                    LoginPref.setLoginStatus(true);
                    LoginPref.setUserData(selectedUser);

                    gotoScreen(selectedUser);
                  }else{
                    ToastUtil.showToast(context, "Invalid password. Login failed");
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: loginButton,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  InputDecoration decoration(String title, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.grey,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0),
        borderSide:
        const BorderSide(color: MyColors.mainColor, width: 1.0),
      ),
      hintText: title,
      hintStyle: TextStyle(
          fontSize: 15.0,
          color: const Color(0xff94A5A6)),
      contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0),
        borderSide:
        const BorderSide(color: const Color(0xffD4D4D4), width: 1.0),
      ),
    );
  }

  Widget levelWidget(context, title, isSelected) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 30,
        ),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFf36408) : Color(0xffC9C4C4),
            border: Border.all(
                color: isSelected ? Color(0xFFf36408) : Color(0xffC9C4C4),
                width: 1.0),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0A0A0A)),
        ),
      ],
    );
  }

  Future<dynamic> showLevelsAlertDialog(context){

    floorSelected = false;
    kitchenSelected = false;
    adminSelected = false;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setModelState) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18)),
                  title: Column(
                    children: <Widget>[
                      Text(
                        "Select Status",
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0C0B0B),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          setModelState(() {

                            selectedUser = "Admin";

                            adminSelected = true;
                            kitchenSelected = false;
                            floorSelected = false;
                          });
                        },
                        child: levelWidget(
                            context, "Admin", adminSelected),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          setModelState(() {

                            selectedUser = "Kitchen User";

                            adminSelected = false;
                            kitchenSelected = true;
                            floorSelected = false;
                          });
                        },
                        child: levelWidget(
                            context, "Kitchen User", kitchenSelected),
                      ),

                      SizedBox(
                        height: 24.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          setModelState(() {
                            selectedUser = "Floor User";

                            adminSelected = false;
                            kitchenSelected = false;
                            floorSelected = true;
                          });
                        },
                        child: levelWidget(
                            context, "Floor User", floorSelected),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),

                      GestureDetector(
                        onTap: () {

                          Navigator.pop(context);

                          setState(() {

                          });
                        },
                        child: Text(
                          "Done",
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF8E44AD),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  gotoScreen(String type){
      Util.pushAndRemoveUntil(_scaffoldKey.currentContext, new AdminMainPanelScreen());

  }
}
