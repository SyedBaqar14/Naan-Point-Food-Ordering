import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ordertakingapp/screens/TableScreen.dart';
import 'package:ordertakingapp/screens/ViewOrdersScreen.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/LoginPref.dart';
import 'package:ordertakingapp/util/ToastUtil.dart';
import 'package:ordertakingapp/util/Util.dart';

import 'LoginScreen.dart';
import 'MainOrderPunchingScreen.dart';
import 'SelectionScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: MyColors.mainColor,
      centerTitle: true,
      leading:  IconButton(
        onPressed: (){ Util.pushAndRemoveUntil(context, new SelectionScreen());
        },
        icon: Icon(Icons.settings, color: Colors.white,),
      ),
      title: Text(
        "HOME",
        style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400),
      ),

      actions: <Widget>[
        IconButton(
          onPressed: () {
            LoginPref.clearPreference();
            Util.navigateView(context, new ViewOrdersScreen());
          },
          icon: Icon(Icons.format_list_bulleted,
            size: 24.0,
            color: Colors.white,
          ),
        ),
      ],
    );

    final body = SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                GestureDetector(
                  onTap: (){
                    Util.navigateView(context, new TablesScreen());
                  },
                  child: Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 200,
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/naanpoint.jpg",
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withOpacity(0.4)),
                            child: Center(
                              child: Text(
                                "DINE IN",
                                style: TextStyle(
                                    fontSize: 35.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.0,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.0,),

                GestureDetector(
                  onTap: (){
                    showNameDialog(context);
                  },
                  child: Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 200,
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/naanpoint.jpg",
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withOpacity(0.4)),
                            child: Center(
                              child: Text(
                                "TAKE AWAY",
                                style: TextStyle(
                                    fontSize: 35.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.0,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }


  @override
  void dispose() {
    super.dispose();

    textEditingController.dispose();
  }

  TextEditingController textEditingController = new TextEditingController();

  Future<void> modalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40.0), ),),
        context: context,
        builder: (context) {
          return Wrap(
            children : <Widget>[
              StatefulBuilder(builder: (BuildContext context,
                  StateSetter setState /*You can rename this!*/) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Text(
                              "Take Away Name",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 25.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),

                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: TextFormField(
                            controller: textEditingController,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            decoration: decoration("Customer Name", Icons.person),
                          ),
                        ),

                        SizedBox(height: 20.0),

                        GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: MyColors.mainColor,
                            ),
                            child: Center(
                              child: Text(
                                "Next",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.0) ,

                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        });
  }
  InputDecoration decoration(String title, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: MyColors.mainColor,
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

  Future<dynamic> showNameDialog(context) {

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          textEditingController.text = "";

          return StatefulBuilder(builder: (context, setState) {

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18)),
              title: Column(
                children: <Widget>[

                  ////
                  GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        textEditingController.text = "";
                      },
                      child: Align(alignment: Alignment.topRight,child: Icon(Icons.close, color: Colors.red, size: 40,))),

                  SizedBox(
                    height: 30.0,
                  ),

                  Text(
                    "Take Away Name",
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

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: TextFormField(
                      controller: textEditingController,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      decoration: decoration("Customer Name", Icons.person),
                    ),
                  ),

                  SizedBox(height: 20.0),

                  GestureDetector(
                    onTap: (){
                      if(textEditingController.text.isEmpty){
                        ToastUtil.showToast(context, "Must enter customer name");
                        return;
                      }
                      Navigator.pop(context);
                      Util.navigateView(context, new OrderPunchingScreen(isDineInOrder: false, tables: null, name: textEditingController.text.toString()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: MyColors.mainColor,
                      ),
                      child: Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0) ,

                ],
              ),
            );
          });
        });
  }


}


