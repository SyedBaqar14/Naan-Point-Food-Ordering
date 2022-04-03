import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordertakingapp/firebasehelper/FirebaseHandler.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/ToastUtil.dart';

class TablesClearScreen extends StatefulWidget {
  @override
  _TablesClearScreenState createState() => _TablesClearScreenState();
}

class _TablesClearScreenState extends State<TablesClearScreen> {
  Stream tableStream;
  FirebaseHandler _firebaseHandler1 = new FirebaseHandler();

  @override
  void initState() {
    super.initState();

    _firebaseHandler1.getTables().then((val) {
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

//    final body = SafeArea(
//      child: Center(
//        child: GestureDetector(
//          onTap: (){
//            _updateDataTables(context);
//          },
//          child: Container(
//            width: MediaQuery.of(context).size.width,
//            height: 60.0,
//            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
//            margin: EdgeInsets.symmetric(horizontal: 15.0),
//            decoration: BoxDecoration(
//                color: MyColors.mainColor,
//                borderRadius: BorderRadius.circular(16.0)
//            ),
//            child: Center(
//              child: Text(
//                "Reset Tables",
//                style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 17.0
//                ),
//              ),
//            ),
//          ),
//        ),
//      ),
//    );

    final body = SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: StreamBuilder(
          stream: tableStream,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Container(
                child: Center(
                  child: Text(
                    "No Items found.",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: MyColors.mainColor),
                  ),
                ),
              )
                  :
              ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder:
              (BuildContext context, int index) {
                  return buildRow(context,
                      snapshot.data.documents[index].data["tableName"],
                      snapshot.data.documents[index].data["tableID"],
                      snapshot.data.documents[index].data["tableStatus"],
                  );
                }
              );
            }
        ),

      ),
    );

    return Scaffold(
      appBar:appBar,
      body:body,
    );
  }

 Widget buildRow(BuildContext context, String tableName, String tableID, bool tableStatus){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.mainColor, width: 1.0, style: BorderStyle.solid)
      ),
      child: Row(
        children: <Widget>[
          Text(
            tableName,
            style: TextStyle(
              fontSize: 23.0,
              fontWeight: FontWeight.w600,
              color: Colors.black
            ),

          ),

          Spacer(),

          Switch(
            value: tableStatus,
            onChanged: (value) {
              setState(() {
                //isSwitched = value;
                tableStatus = value;

                 _firebaseHandler1.updateTableStatus2(tableID: tableID, status: value).then((value){
                  ToastUtil.showToast(context, "Reset successful.");
                });
              });
            },
            activeTrackColor: MyColors.textColor1,
            activeColor: MyColors.mainColor,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _updateDataTables(BuildContext context) {
    tableStream.listen((snapshot) async {
      print(snapshot.documents.length);

      if(snapshot.documents != null && snapshot.documents.length > 0){
        for (int loop = 0; loop < snapshot.documents.length; loop++) {

          bool tableStatus = snapshot.documents[loop].data["tableStatus"];
          String tableID = snapshot.documents[loop].data["tableID"];

          print("${tableID} ${tableStatus}");

          if(tableStatus){

          }
        }
      }
    });
    Get.back();

  }
}
