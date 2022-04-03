import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ordertakingapp/firebasehelper/FirebaseHandler.dart';
import 'package:ordertakingapp/model/Table.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/ToastUtil.dart';
import 'package:ordertakingapp/util/Util.dart';

import 'MainOrderPunchingScreen.dart';

class TablesScreen extends StatefulWidget {
  @override
  _TablesScreenState createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  Stream tableStream;

  FirebaseHandler _firebaseHandler = new FirebaseHandler();

  Tables _table = null;

  int checkedIndex = -1;

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
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          (Platform.isIOS) ? Icons.arrow_back_ios : Icons.arrow_back,
          size: 20.0,
          color: Colors.white,
        ),
      ),
      title: Text(
        "Select Table",
        style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400),
      ),
    );

    final body = SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
//      child: ListView.builder(itemBuilder: null),
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
                : Column(
                  children: <Widget>[
                    GridView.builder(
                        controller: new ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                ((MediaQuery.of(context).size.width / 2) - 40) /
                                    80),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: tableTile(
                              tableID:
                                  snapshot.data.documents[index].data["tableID"],
                              tableName:
                                  snapshot.data.documents[index].data["tableName"],
                              tableStatus: snapshot
                                  .data.documents[index].data["tableStatus"],

                              index: index,
                            ),
                          );
                        }),

                    SizedBox(height: 50,),

                    InkWell(
                      onTap: () {
                        if(_table != null){
                          Util.navigateView(context, new OrderPunchingScreen(isDineInOrder: true, tables: _table, name: "",));
                        }else{
                          ToastUtil.showToast(context, "Must select table first.");
                        }
                      },
                      child: Container(

                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: MyColors.mainColor
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Proceed",
                              style: TextStyle(
                                color: Colors.white,
                                  fontSize: 17.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600),
                            ),

                            SizedBox(width: 10.0,),

                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
          },
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  Widget tableTile({String tableID, String tableName, bool tableStatus, int index}) {

    bool checked = index == checkedIndex;
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          if (!tableStatus) {

            ToastUtil.showToast(
                context, "Selected $tableName");

            setState(() {
              checkedIndex = index;

              _table = new Tables(
                  tableID: tableID,
                  tableName: tableName,
                  tableStatus: tableStatus);
            });

          } else {
            ToastUtil.showToast(
                context, "Table already filled. Please select other table.");

            setState(() {
              _table = null;

              checkedIndex = -1;
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (tableStatus) ? Colors.redAccent : (checked) ? MyColors.mainColor : Colors.green,
          ),
          child: Center(
            child: Text(
              tableName,
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
