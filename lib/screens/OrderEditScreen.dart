import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ordertakingapp/firebasehelper/FirebaseHandler.dart';
import 'package:ordertakingapp/model/Cart.dart';
import 'package:ordertakingapp/model/Food.dart';
import 'package:ordertakingapp/model/MyOrderedFoodList.dart';
import 'package:ordertakingapp/model/Table.dart';
import 'package:ordertakingapp/screens/HomeScreen.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/ToastUtil.dart';
import 'package:ordertakingapp/util/Util.dart';
import 'package:ordertakingapp/util/values.dart';
import 'package:ordertakingapp/widgets/food_card.dart';
import 'package:random_string/random_string.dart';

class OrderEditScreen extends StatefulWidget {
  bool isDineInOrder = true;
  String orderId;
  String orderDate;
  String customerName;
  String orderTime;
  String tableName;
  String orderTotal;
  String orderStatus;
  String paymentStatus;
  List<Food> orderLis;
  String tableId;

  OrderEditScreen({
    this.isDineInOrder,
    this.orderId,
    this.customerName,
    this.orderDate,
    this.tableName,
    this.orderTime,
    this.orderTotal,
    this.orderStatus,
    this.paymentStatus,
    this.orderLis,
    this.tableId,
  });

  @override
  _OrderEditScreenState createState() => _OrderEditScreenState();
}

class _OrderEditScreenState extends State<OrderEditScreen> {
  Stream itemStream;

  FirebaseHandler _firebaseHandler = new FirebaseHandler();

  bool isDineInOrder = true;
  Tables tables;

  String orderID;
  String tableId;
  String tableName;

  Food _food = null;

  List<Food> orderdItemsList = null;

  bool isLoading = false;

  PersistentBottomSheetController _controller; // <------ Instance variable
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String date;
  String time;
  String customerName;



  @override
  void initState() {
    super.initState();

    isDineInOrder = widget.isDineInOrder;
    orderdItemsList = null;

    print(widget.orderLis.length);

    addAll(foods: widget.orderLis);

    orderdItemsList = getItemsList();

    if(isDineInOrder){
      tableId = widget.tableId;
      tableName = widget.tableName;
    }

    orderID = widget.orderId;
    date = widget.orderDate;
    time = widget.orderTime;
    customerName = widget.customerName;

    _firebaseHandler.getFoodData().then((val) {
      setState(() {
        itemStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          (Platform.isIOS) ? Icons.arrow_back_ios : Icons.arrow_back,
          size: 20.0,
          color: Colors.black,
        ),
      ),
      title: Text(
        "Edit Order",
        style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600),
      ),
    );

    final body = Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  (isDineInOrder) ? "Order ID:" : "Name:     ",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 30.0,
                ),
                Text(
                  (isDineInOrder) ? orderID : customerName,
                  style: TextStyle(
                      fontSize: 22.0,
                      color: MyColors.mainColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          (isDineInOrder)
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Table #:",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                      Text(
                        "${tableName}",
                        style: TextStyle(
                            fontSize: 22.0,
                            color: MyColors.mainColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : Container(),
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Type:",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 60.0,
                ),
                Text(
                  "${(isDineInOrder) ? "Dine in" : "Take Away"}",
                  style: TextStyle(
                      fontSize: 22.0,
                      color: MyColors.mainColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(
            height: 1.0,
            thickness: 1.3,
            color: MyColors.mainColor,
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: StreamBuilder(
              stream: itemStream,
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
                    : buildFoodList(snapshot);
              },
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: appBar,
      body: body,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15.0, bottom: 10.0),
        child: FloatingActionButton(
          backgroundColor: MyColors.mainColor,
          onPressed: () {

            setState(() {
              orderdItemsList = null;
              orderdItemsList = getItemsList();
            });

            if(orderdItemsList == null){
              ToastUtil.showToast(context, "No items in order.");
                return;
            }

            if(orderdItemsList.length > 0) {

              modalBottomSheet();
            }else{
              ToastUtil.showToast(context, "No items in order.");
            }
          },
          child: Icon(
            Icons.format_list_bulleted,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

//  Widget buildFoodList(snapshot) {
//    return GridView.builder(
//        shrinkWrap: true,
//        physics: BouncingScrollPhysics(),
//        itemCount: snapshot.data.documents.length,
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//          childAspectRatio: 0.70,
//          mainAxisSpacing: 15,
//          crossAxisSpacing: 5,
//          crossAxisCount: 2,
//        ),
//        itemBuilder: (context, index) {
//          _food = new Food(
//            id: snapshot.data.documents[index].data["id"],
//            name: snapshot.data.documents[index].data["name"],
//            price: snapshot.data.documents[index].data["price"],
//            image: snapshot.data.documents[index].data["image"],
//            qty: 1,
//              isUpdate: 0,
//          );
//
//          return FoodCard(
//            food: _food,
//            type: 1,
//          );
//        });
//  }

  Widget buildFoodList(snapshot) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      shrinkWrap: false,
      physics: ClampingScrollPhysics(),
      itemCount: snapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index) {
        _food = new Food(
            id: snapshot.data.documents[index].data["id"],
            name: snapshot.data.documents[index].data["name"],
            price: snapshot.data.documents[index].data["price"],
            image: snapshot.data.documents[index].data["image"],
            qty: 1,
            isUpdate: 0
        );

        return FoodCard(
          food: _food,
          type: 1,
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 1.0,
    );
  }


  Future<void> modalBottomSheet() {
    return showModalBottomSheet(
      clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(40.0), ),),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Text(
                                "Your Order",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 25.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: Colors.grey[300],
                          ),
                          Container(
                            child: Expanded(
                              child: ListView.builder(
                                  itemCount: orderdItemsList.length,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return orderedItemsList(
                                        setModalState: setState,
                                        food: orderdItemsList[index]);
                                  }),
                            ),
                          ),

                          SizedBox(height: 20.0),

                          Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: Colors.grey[300],
                          ),

                          SizedBox(height: 20.0),

                          Row(
                            children: <Widget>[
                              Text(
                                "Total:",
                                style: TextStyle(
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                "KR ${getTotalPrice()}",
                                style: TextStyle(
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),

                          SizedBox(height: 20.0),

                          GestureDetector(
                            onTap: (){
                              if(getItemsList().length > 0){

                                Util.showLoader(context);

                                if(isDineInOrder){
                                  var data = new DineInCart(
                                      orderID: orderID,
                                      orderDate: date,
                                      orderTime: time,
                                      orderType: "Dine In",
                                      paymentStatus: "Un Paid",
                                      paidBy: "Not Paid Yet",
                                      orderStatus: "Reopen Order",
                                      tableNumber: tableName,
                                      customerName: null,
                                      tableId: tableId,
                                      orderUpdate: null,
                                      orderTotal: getTotalPrice().toString(),
                                      orderedItems: getItemsList());

                                      _firebaseHandler.updateDineOrder(cartData: data, orderID: orderID).then((value){

                                      _firebaseHandler.updateTableStatus(tableID: tableId, status: true).then((value){
                                        ToastUtil.showToast(context, "Order updated successful.");
                                        Util.hideLoader(context);

                                        Util.pushAndRemoveUntil(context, new HomeScreen());
                                      });
                                  });

                                }else{
                                  var data = new DineInCart(orderID: orderID,
                                      orderDate: date,
                                      orderTime: time,
                                      customerName: customerName,
                                      orderType: "Take Away",
                                      paymentStatus: "Un Paid",
                                      paidBy: "Not Paid Yet",
                                      orderStatus: "Booked",
                                      tableNumber: null,
                                      tableId: null,
                                      orderTotal: getTotalPrice().toString(),
                                      orderUpdate: null,
                                      orderedItems: getItemsList());

                                  _firebaseHandler.punchTakeAwayOrder(cartData: data, orderID: orderID).then((value) {
                                    ToastUtil.showToast(context, "Order successful.");
                                    Util.hideLoader(context);
                                    Util.pushAndRemoveUntil(context, new HomeScreen());

                                  });
                                }
                              }else{
                                ToastUtil.showToast(context, "Must add items to order");
                              }
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
                                  "Place Order",
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
          });
        });
  }

  Widget orderedItemsList({StateSetter setModalState,Food food}) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[

          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                setModalState(() {

                  isLoading = true;

                  removeItem(food: food);

                  orderdItemsList = null;
                  orderdItemsList = getItemsList();
                  getTotalPrice();

                  isLoading = false;

                });
              },
              child: Container(
                color: MyColors.mainColor,
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),

          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${food.name}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Text(
                "KR ${food.price}",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w200,
                    color: Colors.black),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),

          (food.isNew == 1) ?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              InkWell(
                onTap: (){
                  subtract(food: food);

                  setModalState(() {
                    orderdItemsList = null;
                    orderdItemsList = getItemsList();
                    getTotalPrice();

                    if(getTotalPrice() > 0){

                    }else{
                      Navigator.pop(context);
                    }
                  });
                },
                child: Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 1.0)
                  ),
                  child: Center(child: Text("-", style: TextStyle(fontSize: 30.0),)),
                ),
              ),

              SizedBox(width: 20,),

              Text(
                "${food.qty}",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),

              SizedBox(width: 20,),

              InkWell(
                onTap: (){
                  add(food: food);

                  setModalState(() {
                    orderdItemsList = null;
                    orderdItemsList = getItemsList();
                    getTotalPrice();

                  });
                },
                child: Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 1.0)
                  ),
                  child: Center(child: Text("+", style: TextStyle(fontSize: 30.0),)),
                ),
              ),
            ],
          ) : Container(
            child:
              Text(
                "Qty: ${food.qty}",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
          ),

          SizedBox(
            height: 10.0,
          ),

          Divider(
            height: 1.0,
            thickness: 1.0,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
