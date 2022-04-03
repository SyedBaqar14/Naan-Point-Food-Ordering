import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordertakingapp/model/Food.dart';

class DineInCart{

  String orderID;
  String orderDate;
  String orderTime;
  String orderType;
  String tableNumber;
  String tableId;
  String orderStatus;
  String orderTotal;
  String customerName;
  String paymentStatus;
  String paidBy;
  List<Food> orderedItems;
  List<Food> orderUpdate;

  DineInCart({
    this.orderID,
    this.orderDate,
    this.orderTime,
    this.orderType,
    this.orderStatus,
    this.customerName,
    this.orderTotal,
    this.tableNumber,
    this.paymentStatus,
    this.paidBy,
    this.orderedItems,
    this.orderUpdate,
    this.tableId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderID'] = this.orderID;
    data['orderDate'] = this.orderDate;
    data['orderTime'] = this.orderTime;
    data['orderType'] = this.orderType;
    data['customerName'] = this.customerName;
    data['orderStatus'] = this.orderStatus;
    data['tableNumber'] = this.tableNumber;
    data['tableId'] = this.tableId;
    data['orderTotal'] = this.orderTotal;
    data['paymentStatus'] = this.paymentStatus;
    data['paidBy'] = this.paidBy;
    data['orderedItems'] = this.orderedItems != null ?
    this.orderedItems.map((v) => v.toJson()).toList()
        : null;

    data['orderUpdate'] = this.orderUpdate != null ?
    this.orderUpdate.map((v) => v.toJson()).toList()
        : null;
    return data;
  }

  DineInCart.fromSnapshot(DocumentSnapshot snapshot)
      : orderID = snapshot.documentID,
        customerName = snapshot['customerName'],
        orderDate = snapshot['orderDate'],
        orderTime = snapshot['orderTime'],
        orderType = snapshot['orderType'],
        orderStatus = snapshot['orderStatus'],
        tableNumber = snapshot['tableNumber'],
        tableId = snapshot['tableId'],
        orderTotal = snapshot['orderTotal'],
        paymentStatus = snapshot['paymentStatus'],
        paidBy = snapshot['paidBy'],
        orderedItems = List.from(snapshot['orderedItems']),
        orderUpdate = List.from(snapshot['orderUpdate']);
}

class TakeAwayCart{

  String orderID;
  String customerName;
  String orderDate;
  String orderTime;
  String orderType;
  String orderStatus;
  String paymentStatus;
  String paidBy;
  String orderTotal;
  List<Food> orderedItems;

  TakeAwayCart({this.orderID,
    this.orderDate,
    this.orderTime,
    this.customerName,
    this.orderType,
    this.orderStatus,
    this.orderTotal,
    this.paymentStatus,
    this.paidBy,
    this.orderedItems});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderID'] = this.orderID;
    data['customerName'] = this.customerName;
    data['orderDate'] = this.orderDate;
    data['orderTime'] = this.orderTime;
    data['orderType'] = this.orderType;
    data['orderStatus'] = this.orderStatus;
    data['orderTotal'] = this.orderTotal;
    data['paymentStatus'] = this.paymentStatus;
    data['paidBy'] = this.paidBy;
    data['orderedItems'] = this.orderedItems != null ?
    this.orderedItems.map((v) => v.toJson()).toList()
        : null;
    return data;
  }

  TakeAwayCart.fromSnapshot(DocumentSnapshot snapshot)
      : orderID = snapshot.documentID,
        customerName = snapshot['customerName'],
        orderDate = snapshot['orderDate'],
        orderTime = snapshot['orderTime'],
        orderType = snapshot['orderType'],
        orderStatus = snapshot['orderStatus'],
        orderTotal = snapshot['orderTotal'],
        paymentStatus = snapshot['paymentStatus'],
        paidBy = snapshot['paidBy'],
        orderedItems = List.from(snapshot['orderedItems']);
}