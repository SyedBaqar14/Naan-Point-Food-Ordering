import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ordertakingapp/firebasehelper/FirebaseHandler.dart';
import 'package:ordertakingapp/model/Food.dart';
import 'package:ordertakingapp/screens/LoginScreen.dart';
import 'package:ordertakingapp/screens/SelectionScreen.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/LoginPref.dart';
import 'package:ordertakingapp/util/ToastUtil.dart';
import 'package:ordertakingapp/util/Util.dart';
import 'package:ordertakingapp/util/values.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ordertakingapp/widgets/button.dart';

class MainKitchenScreen extends StatefulWidget {
  @override
  _MainKitchenScreenState createState() => _MainKitchenScreenState();
}

class _MainKitchenScreenState extends State<MainKitchenScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      unselectedLabelColor: Colors.black.withOpacity(.54),
      labelColor: Colors.white,
      indicatorColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2.0,
      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      tabs: [
        new Tab(
          text: "Dine In".toUpperCase(),
        ),
        new Tab(
          text: "Take Away".toUpperCase(),
        ),
      ],
      controller: _tabController,
    );

    final appBar = AppBar(
      backgroundColor: MyColors.mainColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Kitchen Screen",
        style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400),
      ),
      bottom: tabBar,
    );

    return Scaffold(
      appBar: appBar,
      body: new TabBarView(
        controller: _tabController,
        children: [
          new DineInScreen(),
          new TakeAwayScreen(),
        ],
      ),
    );
  }
}

class DineInScreen extends StatefulWidget {
  @override
  _DineInScreenState createState() => _DineInScreenState();
}

class _DineInScreenState extends State<DineInScreen> {
  Stream dineInStream;

  FirebaseHandler _firebaseHandler = new FirebaseHandler();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String dineInOrderStatus = "";

  bool servedSelected = false;
  bool preparingSelected = false;
  bool kitchenSelected = false;


  @override
  void initState() {
    super.initState();

    _firebaseHandler
        .getDineInOrdersForKitchenWithoutServed(orderDate: Util.getCurrentDate(), type: "Dine In")
        .then((val) {
      setState(() {
        dineInStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: StreamBuilder(
            stream: dineInStream,
            builder: (context, snapshot) {
//              print(snapshot.data.documents);
              return (snapshot.data ==
                      null) // && snapshot.data.documents.length > 0 )
                  ? Container(
                      child: Center(
                          child: Text(
                        "No Dine In Order For Today",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600),
                      )),
                    )
                  : (snapshot.data.documents.length > 0)
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(child: buildStaggeredView(snapshot)),
                      )
                      : Container(
                          child: Center(
                              child: Text(
                            "No Dine In Order For Today",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w600),
                          )),
                        );
            }),
      ),
    );
  }

  Widget buildStaggeredView(snapshot) {
    return new StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      shrinkWrap: false,
      physics: ClampingScrollPhysics(),
      itemCount: snapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index) {
        List<Food> orderedItems = snapshot
            .data.documents[index].data["orderedItems"]
            .map<Food>((item) {
          return Food.fromJson(item);
        }).toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: dineInOrderTile(
            orderId: snapshot.data.documents[index].data["orderID"],
            orderTime: snapshot.data.documents[index].data["orderTime"],
            orderDate: snapshot.data.documents[index].data["orderDate"],
            tableName: snapshot.data.documents[index].data["tableNumber"],
            orderTotal: snapshot.data.documents[index].data["orderTotal"],
            orderStatus: snapshot.data.documents[index].data["orderStatus"],
            paymentStatus: snapshot.data.documents[index].data["paymentStatus"],
            tableId: snapshot.data.documents[index].data["tableId"],
            orderList: orderedItems,
          ),
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 15.0,
    );
  }

  Widget dineInOrderTile(
      {String orderId,
      String orderDate,
      String orderTime,
      String tableName,
      String orderTotal,
      String orderStatus,
      String paymentStatus,
      List<Food> orderList,
      String tableId}) {
    dineInOrderStatus = orderStatus;

    List<Food> dataaa = orderList;
    List<Food> dataaa2 = new List();

    for(Food xyz in dataaa){

      dataaa2.add(new Food(name: xyz.name, price: xyz.price, id: xyz.id,
          isUpdate: 0, qty: xyz.qty, image: xyz.name));
    }

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.only(right: 0),
      shape: roundedRectangle12,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: Column(
          children: <Widget>[
            Text(
              "${tableName}",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: MyColors.mainColor),
            ),
            SizedBox(
              height: 15.0,
            ),
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: Colors.black26,
            ),
            SizedBox(
              height: 10.0,
            ),
            ListView.builder(
                itemCount: orderList.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  print("(${orderList[index].qty})   ${orderList[index].name}  ${orderList[index].isUpdate}");
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "(${orderList[index].qty})   ${orderList[index].name}",
                          style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500,
                              color: (orderList[index].isNew == 1) ?  Colors.red : Colors.black),
                        ),

                        SizedBox(
                          height: 5.0,
                        ),
                        Divider(height: 1.0, thickness: 1.0, color: Colors.black26,)
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 15.0,
            ),
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: Colors.black26,
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                showLevelsAlertDialog(context, orderId, dataaa2);
              },
              child: Column(
                children: <Widget>[
                  Text(
                    dineInOrderStatus,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: MyColors.mainColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget levelWidget(context, title, isSelected) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
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

  Widget levelWidget2(context, title, isSelected) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
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

  Future<dynamic> showLevelsAlertDialog(context, String orderID, List<Food> foodData) {
    servedSelected = false;
    preparingSelected = false;
    kitchenSelected = false;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStates) {
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
                  InkWell(
                    onTap: () {
                        updateStatus( orderID, "In Kitchen", foodData );
                    },
                    child: Button( title: "In Kitchen" ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  InkWell(
                    onTap: () {

                          updateStatus(orderID, "Preparing", foodData);

                    },
                    child: Button( title: "Preparing" ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  InkWell(
                    onTap: () {

                        updateStatus(orderID, "Served", foodData);

                    },
                    child: Button( title: "Served" ),
                  ),
                ],
              ),
            );
          });
        });
  }

  updateStatus(orderID, status, foodData){
    Navigator.of(_scaffoldKey.currentContext).pop();

    Util.showLoader(_scaffoldKey.currentContext);

    _firebaseHandler
        .updateDineInOrderKitchenStatus(
        orderID: orderID, status: status)
        .then((value) {

      _firebaseHandler
          .updateDineInOrderKitchenUpdateItems( orderID: orderID, foodData: foodData).then((value) {

        ToastUtil.showToast(_scaffoldKey.currentContext, "Order status updated successfully");

        Util.hideLoader(_scaffoldKey.currentContext);
      });
    });
  }
}

class TakeAwayScreen extends StatefulWidget {
  @override
  _TakeAwayScreenState createState() => _TakeAwayScreenState();
}

class _TakeAwayScreenState extends State<TakeAwayScreen> {
  Stream takeAwayStream;

  FirebaseHandler _firebaseHandler = new FirebaseHandler();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String takeAwayOrderStatus;

  bool servedSelected = false;
  bool preparingSelected = false;
  bool kitchenSelected = false;


  @override
  void initState() {
    super.initState();

    _firebaseHandler
        .getDineInOrdersForKitchenWithoutServed(orderDate: Util.getCurrentDate(), type: "Take Away")
        .then((val) {
      setState(() {
        takeAwayStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: StreamBuilder(
            stream: takeAwayStream,
            builder: (context, snapshot) {
//              print(snapshot.data.documents);
              return (snapshot.data ==
                      null) // && snapshot.data.documents.length > 0 )
                  ? Container(
                      child: Center(
                          child: Text(
                        "No Take Away Order For Today",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600),
                      )),
                    )
                  : (snapshot.data.documents.length > 0)
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          child: buildStaggeredView(snapshot),
                        )
                      : Container(
                          child: Center(
                              child: Text(
                            "No Take Away Order For Today",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w600),
                          )),
                        );
            }),
      ),
    );
  }

  Widget takeAwayOrderTile({
    String orderId,
    String customerName,
    String orderDate,
    String orderTime,
    String tableName,
    String orderTotal,
    String orderStatus,
    String paymentStatus,
    List<Food> orderList,

  }) {

    takeAwayOrderStatus = orderStatus;

    List<Food> dataaa = orderList;
    List<Food> dataaa2 = new List();

    for(Food xyz in dataaa){

      dataaa2.add(new Food(name: xyz.name, price: xyz.price, id: xyz.id, isNew: (takeAwayOrderStatus == "Served") ? 0 : 1,
          isUpdate: (takeAwayOrderStatus == "Served") ? 0 : 1, qty: xyz.qty, image: xyz.name));
    }

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.only(right: 0),
      shape: roundedRectangle12,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: Column(
          children: <Widget>[
            Text(
              "Name: ${customerName}",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: MyColors.mainColor),
            ),
            SizedBox(
              height: 10.0,
            ),

            Text(
              "Time: ${orderTime}",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: MyColors.mainColor),
            ),
            SizedBox(
              height: 15.0,
            ),

            Divider(
              thickness: 1.0,
              height: 1.0,
              color: Colors.black26,
            ),
            SizedBox(
              height: 10.0,
            ),
            ListView.builder(
                itemCount: orderList.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "(${orderList[index].qty})   ${orderList[index].name}",
                          style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500,
                              color: (orderList[index].isNew == 1) ?  Colors.red : Colors.black),
                        ),

                        SizedBox(
                          height: 5.0,
                        ),
                        Divider(height: 1.0, thickness: 1.0, color: Colors.black26,)
                      ],
                    ),
                  );
                }),

            SizedBox(
              height: 15.0,
            ),
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: MyColors.mainColor,
            ),
            SizedBox(
              height: 15.0,
            ),
            GestureDetector(
              onTap: () {
                showLevelsAlertDialog(context, orderId, dataaa2);
              },
              child: Column(
                children: <Widget>[
                  Text(
                    "${takeAwayOrderStatus}",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: MyColors.mainColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStaggeredView(snapshot) {
    return new StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      shrinkWrap: false,
      physics: ClampingScrollPhysics(),
      itemCount: snapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index) {
        List<Food> orderedItems = snapshot
            .data.documents[index].data["orderedItems"]
            .map<Food>((item) {
          return Food.fromJson(item);
        }).toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: takeAwayOrderTile(
            orderId: snapshot.data.documents[index].data["orderID"],
            customerName: snapshot.data.documents[index].data["customerName"],
            orderTime: snapshot.data.documents[index].data["orderTime"],
            orderDate: snapshot.data.documents[index].data["orderDate"],
            tableName: snapshot.data.documents[index].data["tableNumber"],
            orderTotal: snapshot.data.documents[index].data["orderTotal"],
            orderStatus: snapshot.data.documents[index].data["orderStatus"],
            paymentStatus: snapshot.data.documents[index].data["paymentStatus"],
            orderList: orderedItems,
          ),
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 15.0,
    );
  }

  Widget levelWidget(context, title, isSelected) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
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

  updateStatus(orderID, status, foodData){
    Navigator.of(_scaffoldKey.currentContext).pop();

    Util.showLoader(_scaffoldKey.currentContext);
    _firebaseHandler
        .updateTakeAwayOrderKitchenStatus(
        orderID: orderID, status: status)
        .then((value) {

      _firebaseHandler
          .updateTakeAwayOrderKitchenUpdateItems( orderID: orderID, foodData: foodData).then((value) {

        ToastUtil.showToast(_scaffoldKey.currentContext, "Order status updated successfully");

        Util.hideLoader(_scaffoldKey.currentContext);
      });
    });
  }


  Future<dynamic> showLevelsAlertDialog(context, String orderID, List<Food> foodData) {
    servedSelected = false;
    preparingSelected = false;
    kitchenSelected = false;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
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
                  InkWell(
                    onTap: () {

                        updateStatus(orderID, "In Kitchen", foodData);

                    },
                    child: Button( title: "In Kitchen" ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  InkWell(
                    onTap: () {

                        updateStatus(orderID, "Preparing", foodData);
                    },
                    child: Button( title: "Preparing" ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  InkWell(
                    onTap: () {

                        updateStatus(orderID, "Served", foodData);
                    },
                    child: Button( title: "Served" ),
                  ),
                ],
              ),
            );
          });
        });
  }

}
