import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ordertakingapp/firebasehelper/FirebaseHandler.dart';
import 'package:ordertakingapp/model/Cart.dart';
import 'package:ordertakingapp/model/Food.dart';
import 'package:ordertakingapp/screens/OrderEditScreen.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/ToastUtil.dart';
import 'package:ordertakingapp/util/Util.dart';
import 'package:ordertakingapp/util/values.dart';

class ViewOrdersScreen extends StatefulWidget {
  @override
  _ViewOrdersScreenState createState() => _ViewOrdersScreenState();
}

class _ViewOrdersScreenState extends State<ViewOrdersScreen>
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
        "Orders",
        style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400),
      ),
      bottom: tabBar,
    );

    return Scaffold(
      backgroundColor: Colors.white,
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

  @override
  void initState() {
    super.initState();

    _firebaseHandler
        .getDineInOrdersForFloor(orderDate: Util.getCurrentDate(), type: "Dine In")
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
              return (snapshot.data == null) // && snapshot.data.documents.length > 0 )
                  ?  Container(
                child: Center(
                    child: Text(
                      "No Dine In Order For Today",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    )),
              )
                  : (snapshot.data.documents.length > 0)
                  ? Container(
                margin: EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder:
                        (BuildContext context, int index) {
                      List<Food> orderedItems = snapshot.data
                          .documents[index].data["orderedItems"]
                          .map<Food>((item) {
                        return Food.fromJson(item);
                      }).toList();
                      return Padding(
                        padding:
                        const EdgeInsets.only(bottom: 15.0),
                        child: dineInOrderTile(
                          orderId: snapshot.data.documents[index]
                              .data["orderID"],
                          customerName: null,
                          orderTime: snapshot.data
                              .documents[index].data["orderTime"],
                          orderDate: snapshot.data
                              .documents[index].data["orderDate"],
                          tableName: snapshot
                              .data
                              .documents[index]
                              .data["tableNumber"],
                          orderTotal: snapshot
                              .data
                              .documents[index]
                              .data["orderTotal"],
                          orderStatus: snapshot
                              .data
                              .documents[index]
                              .data["orderStatus"],
                          paymentStatus: snapshot
                              .data
                              .documents[index]
                              .data["paymentStatus"],
                          tableId: snapshot
                              .data
                              .documents[index]
                              .data["tableId"],

                          orderList: orderedItems,
                        ),
                      );
                    }),
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

  Widget dineInOrderTile(
      {
        String orderId,
        String customerName,
        String orderDate,
        String orderTime,
        String tableName,
        String orderTotal,
        String orderStatus,
        String paymentStatus,
        List<Food> orderList,
        String tableId
      }) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.only(right: 0),
      shape: roundedRectangle12,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: Column(
          children: <Widget>[
            Text(
              "Order ID: ${orderId}",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: MyColors.mainColor),
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Order Time",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "${orderTime}",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: MyColors.mainColor),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Table #",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "${tableName}",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: MyColors.mainColor),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
              height: 15.0,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Order Status",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "${orderStatus}",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: MyColors.mainColor),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Payment Status",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "${paymentStatus}",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: MyColors.mainColor),
                    ),
                  ],
                ),
              ],
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
              height: 15.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text("Ordered Items",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600))),
                Text(
                  "Qty",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            orderList[index].name,
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                        Text(
                          "${orderList[index].qty}",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
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
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text("Total",
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45))),
                Text(
                  "${double.parse(orderTotal)}",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: MyColors.mainColor,
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                      onTap: () {

                        Util.navigateView(context, new OrderEditScreen(
                          orderId: orderId,
                          orderStatus: orderStatus,
                          customerName: customerName,
                          orderDate: orderDate,
                          orderTime: orderTime,
                          orderLis: orderList,
                          isDineInOrder: true,
                          paymentStatus: paymentStatus,
                          tableId: tableId,
                          tableName: tableName,
                          orderTotal: orderTotal,
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.orangeAccent,
                        ),
                        child: Center(
                            child: Text(
                              "Edit",
                              style: TextStyle(fontSize: 20.0, color: Colors.white),
                            )),
                      ),
                    )),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if(orderStatus == "Booked"){
                          getUserConsentToDeleteItem(
                              orderID: orderId, tableId: tableId);
                        }else if(orderStatus == "Served"){
                          ToastUtil.showToast(context, "You can not cancel order at this time. Your order is served.");
                        }
                        else{
                          ToastUtil.showToast(context, "You can not cancel order at this time. Your order is currently in making.");
                        }

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.redAccent,
                        ),
                        child: Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(fontSize: 20.0, color: Colors.white),
                            )),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(orderStatus == "Served"){
                        getUserConsentToPayOrder(tableId: tableId, paidBy: "Cash", orderID: orderId);
                      }else{
                        ToastUtil.showToast(context, "You can not make payment at this time. Your order is currently in kitchen.");
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.green,
                      ),
                      child: Center(
                          child: Text(
                            "PAY BY CASH",
                            style: TextStyle(fontSize: 20.0, color: Colors.white),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(orderStatus == "Served"){
                        getUserConsentToPayOrder(tableId: tableId, paidBy: "Credit", orderID: orderId);
                      }else{
                        ToastUtil.showToast(context, "You can not make payment at this time. Your order is currently in kitchen.");
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.green,
                      ),
                      child: Center(
                          child: Text(
                            "PAY BY CREDIT",
                            style: TextStyle(fontSize: 20.0, color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> getUserConsentToDeleteItem({String orderID, String tableId}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 1.4,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18)),
            title: Column(
              children: <Widget>[
                Center(
                    child: Text(
                      'Confirmation',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 2.0,
                  width: 190,
                  color: MyColors.mainColor,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    "Are you sure you want to delete this order?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.pop(_scaffoldKey.currentContext);

                            Util.showLoader(_scaffoldKey.currentContext);

                            _firebaseHandler
                                .updateTableStatus(
                                tableID: tableId, status: false)
                                .then((value) {
                              _firebaseHandler
                                  .deleteDineInOrders(orderId: orderID)
                                  .then((value) {
                                ToastUtil.showToast(_scaffoldKey.currentContext,
                                    "Order deleted successfully. Table status is Available.");

                                Util.hideLoader(_scaffoldKey.currentContext);

                                setState(() {});
                              });
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400),
                              ))),
                      SizedBox(
                        width: 30.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'No',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                    ])
              ],
            ),
          );
        });
  }

  Future<void> getUserConsentToPayOrder({String orderID, String paidBy, String tableId}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 1.4,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18)),
            title: Column(
              children: <Widget>[
                Center(
                    child: Text(
                      'Confirmation',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 2.0,
                  width: 190,
                  color: MyColors.mainColor,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    "Are you sure you want to PAY this order?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.pop(_scaffoldKey.currentContext);

                            Util.showLoader(_scaffoldKey.currentContext);

                            _firebaseHandler
                                .updateOrderStatus(orderID: orderID, paidBy: paidBy)
                                .then((value) {

                              Future.delayed(const Duration(seconds: 2), (){

                                print(tableId);
                                _firebaseHandler
                                    .updateTableStatus(
                                    tableID: tableId, status: false)
                                    .then((value) {
                                  ToastUtil.showToast(_scaffoldKey.currentContext,
                                      "Order Paid successfully. Table status is Available.");

                                  Util.hideLoader(_scaffoldKey.currentContext);

                                  setState(() {});
                                });
                              });
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400),
                              ))),
                      SizedBox(
                        width: 30.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'No',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                    ])
              ],
            ),
          );
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

  @override
  void initState() {
    super.initState();

    _firebaseHandler
        .getDineInOrdersForFloor(orderDate: Util.getCurrentDate(), type: "Take Away")
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
              return (snapshot.data == null) // && snapshot.data.documents.length > 0 )
                  ?  Container(
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
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder:
                        (BuildContext context, int index) {
                      List<Food> orderedItems = snapshot.data
                          .documents[index].data["orderedItems"]
                          .map<Food>((item) {
                        return Food.fromJson(item);
                      }).toList();

                      print(orderedItems.length);
                      return Padding(
                        padding:
                        const EdgeInsets.only(bottom: 15.0),
                        child: dineInOrderTile(
                          orderId: snapshot.data.documents[index]
                              .data["orderID"],
                          name: snapshot.data.documents[index]
                              .data["customerName"],
                          orderTime: snapshot.data
                              .documents[index].data["orderTime"],
                          orderDate: snapshot.data
                              .documents[index].data["orderDate"],
                          tableName: snapshot
                              .data
                              .documents[index]
                              .data["tableNumber"],
                          orderTotal: snapshot
                              .data
                              .documents[index]
                              .data["orderTotal"],
                          orderStatus: snapshot
                              .data
                              .documents[index]
                              .data["orderStatus"],
                          paymentStatus: snapshot
                              .data
                              .documents[index]
                              .data["paymentStatus"],

                          orderList: orderedItems,
                        ),
                      );
                    }),
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

  Widget dineInOrderTile(
      {
        String orderId,
        String name,
        String orderDate,
        String orderTime,
        String tableName,
        String orderTotal,
        String orderStatus,
        String paymentStatus,
        List<Food> orderList,
      }) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.only(right: 0),
      shape: roundedRectangle12,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: Column(
          children: <Widget>[
            Text(
              "Name: ${name}",
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w700,
                  color: MyColors.mainColor),
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Order Time",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "${orderTime}",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: MyColors.mainColor),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Type",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Take Away",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: MyColors.mainColor),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
              height: 15.0,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Order Status",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "${orderStatus}",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: MyColors.mainColor),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Payment Status",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "${paymentStatus}",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: MyColors.mainColor),
                    ),
                  ],
                ),
              ],
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
              height: 15.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text("Ordered Items",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600))),
                Text(
                  "Qty",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            orderList[index].name,
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                        Text(
                          "${orderList[index].qty}",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
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
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text("Total",
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45))),
                Text(
                  "${double.parse(orderTotal)}",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: MyColors.mainColor,
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                      onTap: () {

                        Util.navigateView(context, new OrderEditScreen(
                          orderId: orderId,
                          customerName: name,
                          orderStatus: orderStatus,
                          orderDate: orderDate,
                          orderTime: orderTime,
                          orderLis: orderList,
                          isDineInOrder: false,
                          paymentStatus: paymentStatus,
                          orderTotal: orderTotal,
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.orangeAccent,
                        ),
                        child: Center(
                            child: Text(
                              "Edit",
                              style: TextStyle(fontSize: 20.0, color: Colors.white),
                            )),
                      ),
                    )),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if(orderStatus == "Booked"){
                          getUserConsentToDeleteItem(
                              orderID: orderId);
                        }else if(orderStatus == "Served"){
                          ToastUtil.showToast(context, "You can not cancel order at this time. Your order is served.");
                        }
                        else{
                          ToastUtil.showToast(context, "You can not cancel order at this time. Your order is currently in making.");
                        }

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.redAccent,
                        ),
                        child: Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(fontSize: 20.0, color: Colors.white),
                            )),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(orderStatus == "Served"){
                        getUserConsentToPayOrder(orderID: orderId, paidBy: "CASH");
                      }else{
                        ToastUtil.showToast(context, "You can not make payment at this time. Your order is currently in kitchen.");
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.green,
                      ),
                      child: Center(
                          child: Text(
                            "PAY BY CASH",
                            style: TextStyle(fontSize: 20.0, color: Colors.white),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(orderStatus == "Served"){
                        getUserConsentToPayOrder(orderID: orderId, paidBy: "CREDIT");
                      }else{
                        ToastUtil.showToast(context, "You can not make payment at this time. Your order is currently in kitchen.");
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.green,
                      ),
                      child: Center(
                          child: Text(
                            "PAY BY CREDIT",
                            style: TextStyle(fontSize: 20.0, color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserConsentToDeleteItem({String orderID}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 1.4,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18)),
            title: Column(
              children: <Widget>[
                Center(
                    child: Text(
                      'Confirmation',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 2.0,
                  width: 190,
                  color: MyColors.mainColor,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    "Are you sure you want to delete this order?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.pop(_scaffoldKey.currentContext);

                            Util.showLoader(_scaffoldKey.currentContext);

                            _firebaseHandler
                                .deleteTakeAwayOrders(orderId: orderID)
                                .then((value) {
                              ToastUtil.showToast(_scaffoldKey.currentContext,
                                  "Order deleted successfully. Table status is Available.");

                              Util.hideLoader(_scaffoldKey.currentContext);

                              setState(() {});
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400),
                              ))),
                      SizedBox(
                        width: 30.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'No',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                    ])
              ],
            ),
          );
        });
  }

  Future<void> getUserConsentToPayOrder({String orderID, String paidBy}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 1.4,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18)),
            title: Column(
              children: <Widget>[
                Center(
                    child: Text(
                      'Confirmation',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 2.0,
                  width: 190,
                  color: MyColors.mainColor,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    "Are you sure you want to PAY this order?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.pop(_scaffoldKey.currentContext);

                            Util.showLoader(_scaffoldKey.currentContext);

                            _firebaseHandler
                                .updateTakeawayOrderStatus(orderID: orderID, paidBy: paidBy)
                                .then((value) {

                              ToastUtil.showToast(_scaffoldKey.currentContext,
                                  "Order Paid successfully.");

                              Util.hideLoader(_scaffoldKey.currentContext);

                              setState(() {});

                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400),
                              ))),
                      SizedBox(
                        width: 30.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'No',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                    ])
              ],
            ),
          );
        });
  }
}