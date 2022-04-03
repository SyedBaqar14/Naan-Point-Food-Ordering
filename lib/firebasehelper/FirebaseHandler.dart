import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordertakingapp/model/Cart.dart';
import 'package:ordertakingapp/model/Food.dart';

class FirebaseHandler{


  Future<void> addFoodData(Food foodData, String foodId) async{

    await Firestore.instance.collection("Food")
        .document(foodId).setData(foodData.toJson())
        .catchError((onError){
      print("Firebase Erro : $onError");
    });
  }

  getFoodData() async {
    return await Firestore.instance.collection("Food").snapshots();
  }

  getDineInOrders({String orderDate}) async {
    return await Firestore.instance.collection("DineInOrders")
        .where("orderDate", isEqualTo: orderDate)
        .where("paymentStatus", isEqualTo: "Un Paid")
        .snapshots();
  }

  getDineInOrdersForFloor({String orderDate, String type}) async {
    return await Firestore.instance.collection("Orders")
        .where("orderDate", isEqualTo: orderDate)
        .where("orderType", isEqualTo: type)

        .where("orderStatus", whereIn: ["In Kitchen", "Preparing", "Booked", "Reopen Order", "Served"])
        .where("paymentStatus", isEqualTo: "Un Paid")
        .snapshots();
  }

  getDineInOrdersForKitchenWithoutServed({String orderDate, String type}) async {
    return await Firestore.instance.collection("Orders")
        .where("orderDate", isEqualTo: orderDate)
        .where("orderType", isEqualTo: type)

        .where("orderStatus", whereIn: ["In Kitchen", "Preparing", "Booked", "Reopen Order"])
        .where("paymentStatus", isEqualTo: "Un Paid")
        .snapshots();
  }

  getDineInOrdersPaid({String orderDate}) async {
    return await Firestore.instance.collection("Orders")
        .where("orderDate", isEqualTo: orderDate)
        .where("paymentStatus", isEqualTo: "Paid")
        .snapshots();
  }

  getTakeAwayOrdersPaid({String orderDate}) async {
    return await Firestore.instance.collection("TakeAwayOrders")
        .where("orderDate", isEqualTo: orderDate)
        .where("paymentStatus", isEqualTo: "Paid")
        .snapshots();
  }

  getTakeAwayPaid({String orderDate}) async {
    return await Firestore.instance.collection("TakeAwayOrders")
        .where("orderDate", isEqualTo: orderDate)
        .where("paymentStatus", isEqualTo: "Paid")
        .snapshots();
  }

  getTakeAwayOrdersForKitchen({String orderDate}) async {
    return await Firestore.instance.collection("TakeAwayOrders")
        .where("orderDate", isEqualTo: orderDate)
        .where("orderStatus", whereIn: ["In Kitchen", "Preparing", "Booked", "Reopen Order"])
        .where("paymentStatus", isEqualTo: "Un Paid")
        .snapshots();
  }

  Future<void> deleteDineInOrders({String orderId}) async {
    return await Firestore.instance.collection("DineInOrders").document(orderId).delete().catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> deleteTakeAwayOrders({String orderId}) async {
    return await Firestore.instance.collection("TakeAwayOrders").document(orderId).delete().catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> updateOrderStatus({ String orderID, String paidBy}) async{

    final Map<String, String> data = new Map<String, String>();
    data['paymentStatus'] = "Paid";
    data['paidBy'] = paidBy;

    return await Firestore.instance.collection("Orders")
        .document(orderID).updateData(data)
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> updateTakeawayOrderStatus({ String orderID, String paidBy}) async{

    final Map<String, String> data = new Map<String, String>();
    data['paymentStatus'] = "Paid";
    data['paidBy'] = paidBy;

    return await Firestore.instance.collection("Orders")
        .document(orderID).updateData(data)
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> updateDineInOrderKitchenStatus({ String orderID, String status }) async{

    final Map<String, String> data = new Map<String, String>();
    data['orderStatus'] = status;

    String collection ="Orders";

    return await Firestore.instance.collection(collection)
        .document(orderID).updateData(data)
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> updateDineInOrderKitchenUpdateItems({ String orderID, List<Food> foodData }) async{

    var xx = foodData.map((v) => v.toJson()).toList();

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderedItems'] = xx;


    String collection ="Orders";

    return await Firestore.instance.collection(collection)
        .document(orderID).updateData(data)
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> updateTakeAwayOrderKitchenUpdateItems({ String orderID, List<Food> foodData }) async{

    var xx = foodData.map((v) => v.toJson()).toList();

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderedItems'] = xx;


    String collection ="Orders";

    return await Firestore.instance.collection(collection)
        .document(orderID).updateData(data)
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }


  Future<void> updateTakeAwayOrderKitchenStatus({ String orderID, String status }) async{

    final Map<String, String> data = new Map<String, String>();
    data['orderStatus'] = status;

    String collection ="Orders";

    return await Firestore.instance.collection(collection)
        .document(orderID).updateData(data)
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }


  getTables() async {
    return await Firestore.instance.collection("Table").snapshots();
  }

  Future<void> removeFoodData(String foodID) async {
    return await Firestore.instance.collection("Food").document(foodID).delete().catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> updateTableStatus({String tableID, bool status}) async{

    final Map<String, bool> data = new Map<String, bool>();
    data['tableStatus'] = status;

    return await Firestore.instance.collection("Table")
        .document(tableID).updateData(data)
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> updateTableStatus2({String tableID, bool status}) async{

    final Map<String, bool> data = new Map<String, bool>();
    data['tableStatus'] = status;

    return await Firestore.instance.collection("Table")
        .document(tableID).updateData(data)
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> updateDineOrder({DineInCart cartData, String orderID}) async{

    return await Firestore.instance.collection("Orders")
        .document(orderID).updateData(cartData.toJson())
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> punchDineOrder({DineInCart cartData, String orderID}) async{

    return await Firestore.instance.collection("DineInOrders")
        .document(orderID).setData(cartData.toJson())
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  Future<void> punchTakeAwayOrder({DineInCart cartData, String orderID}) async{

    return await Firestore.instance.collection("Orders")
        .document(orderID).setData(cartData.toJson())
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }

  getTakeAwayOrders({String orderDate}) async {
    return await Firestore.instance.collection("TakeAwayOrders")
        .where("orderDate", isEqualTo: orderDate)
        .where("paymentStatus", isEqualTo: "Un Paid")
        .snapshots();
  }

  Future<void> punchOrder({DineInCart cartData, String orderID}) async{

    return await Firestore.instance.collection("Orders")
        .document(orderID).setData(cartData.toJson())
        .catchError((onError){
      print("Firebase Error : $onError");
    });
  }

}

//D-00567
//D-65414
//T-28064