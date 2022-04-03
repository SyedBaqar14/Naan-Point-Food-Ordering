import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordertakingapp/firebasehelper/FirebaseHandler.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/ToastUtil.dart';


class FreeTableScreen extends StatefulWidget {
  @override
  _FreeTableScreenState createState() => _FreeTableScreenState();
}

class _FreeTableScreenState extends State<FreeTableScreen> {

  Stream tableStream;
  FirebaseHandler _firebaseHandler = new FirebaseHandler();

  @override
  void initState() {
    super.initState();

    _firebaseHandler.getTables().then((val) {
      setState(() {
        tableStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      backgroundColor: MyColors.mainColor,
      centerTitle: true,
      leading: IconButton(
        onPressed: () { Get.back();},
        icon: Icon(
          (Platform.isIOS) ? Icons.arrow_back_ios : Icons.arrow_back,
          size: 20.0,
          color: Colors.white,
        ),
      ),
      title: Text(
        "Reset Tables",
        style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400
        ),
      ),
    );

    final body = SafeArea(
      child: Center(
        child: GestureDetector(
          onTap: (){
            _updateDataTables(context);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 60.0,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              color: MyColors.mainColor,
              borderRadius: BorderRadius.circular(16.0)
            ),
            child: Center(
              child: Text(
                "Reset Tables",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
        appBar:appBar,
      body:body,
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  _updateDataTables(BuildContext context){
    tableStream.listen((snapshot) {
      print(snapshot.documents.length);

        if(snapshot.documents != null && snapshot.documents.length > 0){
          for (int loop = 0; loop < snapshot.documents.length; loop++) {

            bool tableStatus = snapshot.documents[loop].data["tableStatus"];
            String tableID = snapshot.documents[loop].data["tableID"];

            print("${tableID} ${tableStatus}");

            if(tableStatus){
              _firebaseHandler.updateTableStatus(tableID: tableID, status: false).then((value){
//                ToastUtil.showToast(context, "Reset successful.");

              });
            }
          }

        }
      Get.back();
    });
  }
}
