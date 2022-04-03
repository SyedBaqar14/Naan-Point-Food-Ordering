import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ordertakingapp/firebasehelper/FirebaseHandler.dart';
import 'package:ordertakingapp/model/Food.dart';
import 'package:ordertakingapp/screens/AddMenuScreen.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/Util.dart';

class AllMenuListScreen extends StatefulWidget {
  @override
  _AllMenuListScreenState createState() => _AllMenuListScreenState();
}

class _AllMenuListScreenState extends State<AllMenuListScreen> {

  Stream foodStream;

  FirebaseHandler _firebaseHandler = new FirebaseHandler();

  @override
  void initState() {
    super.initState();

    _firebaseHandler.getFoodData().then((val) {
      setState(() {
        foodStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      backgroundColor: MyColors.mainColor,
      centerTitle: true,
      leading: IconButton(
        onPressed: () { Navigator.pop(context);},
        icon: Icon(
          (Platform.isIOS) ? Icons.arrow_back_ios : Icons.arrow_back,
          size: 20.0,
          color: Colors.white,
        ),
      ),
      title: Text(
        "Menu List",
        style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400
        ),
      ),
    );

    final body = SafeArea(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
//      child: ListView.builder(itemBuilder: null),
      child: StreamBuilder(
        stream:  foodStream,
        builder: (context, snapshot){
          return snapshot.data == null
              ? Container(
            child: Center(
              child: Text(
                "No Items found.",
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: MyColors.mainColor
                ),
              ),
            ),):
          ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: itemTile(
                    id: snapshot.data.documents[index].data["id"],
                    name: snapshot.data.documents[index].data["name"],
                    price: snapshot.data.documents[index].data["price"],
                    image: snapshot.data.documents[index].data["image"],
                  ),
                );
              });
        },
      ),
    ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: appBar,
        body: body,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
        child: FloatingActionButton(
          onPressed: (){
           Util.navigateView(context, new AddMenuScreen(id: "", name: "", price: 0.0, isUpdate: false, image: "",));
          },
          child: Icon(Icons.add, color: Colors.white,),
          backgroundColor: MyColors.mainColor,
          elevation: 1.0,
        ),
      ),
    );
  }

  Widget itemTile({String id, String name, double price, String image}){
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      borderOnForeground: true,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: MyColors.mainColor, width: 1.3),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Card(
                color: MyColors.mainColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3.0,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(image, width: 100, height: 100, fit: BoxFit.cover,))),
            ),

            SizedBox(width: 10.0,),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    name.toUpperCase(),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      fontSize: 25.0
                    ),
                  ),

                  Text(
                    "$price (KR)",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: "Poppins",
                        fontSize: 18.0,
                      color: Colors.green
                    ),
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[


                      GestureDetector(
                        onTap: (){
                          Util.navigateView(context, new AddMenuScreen(id: id, name: name, price: price, image: image, isUpdate: true,),);
                        },
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20)
                            ),
                              child: Icon(Icons.edit, color: Colors.black, size: 25,)),
                        ),
                      ),


                      GestureDetector(
                        onTap: (){
                          getUserConsentToDeleteItem(foodID: id);
                        },
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Icon(Icons.delete, color: Colors.red, size: 25,)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 10.0,),
          ],
        ),
      ),
    );
  }

  Future<void> getUserConsentToDeleteItem({String foodID}){
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
                Center(child: Text('Confirmation', style: TextStyle(fontSize: 20.0, fontFamily: "Poppins", fontWeight: FontWeight.w600),)),
                SizedBox(height: 5.0,),
                Container(height: 2.0, width: 190, color: MyColors.mainColor,),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child:  Text(
                    "Are you sure you want to delete this food item?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 17,
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: (){
                            Navigator.pop(context);

                            _firebaseHandler.removeFoodData(foodID);

                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text('Yes', style: TextStyle(color: Colors.green, fontSize: 16.0, fontFamily: "Poppins", fontWeight: FontWeight.w400),))),

                      SizedBox(width: 30.0,),

                      InkWell(
                        onTap: (){Navigator.pop(context);},
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text('No', style: TextStyle(color: Colors.red, fontSize: 16.0, fontFamily: "Poppins", fontWeight: FontWeight.w400),)),
                      ),
                    ])
              ],
            ),
          );
        });
  }

}
