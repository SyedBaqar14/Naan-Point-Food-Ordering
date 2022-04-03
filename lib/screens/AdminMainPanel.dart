import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ordertakingapp/firebasehelper/FirebaseHandler.dart';
import 'package:ordertakingapp/model/Dummy.dart';
import 'package:ordertakingapp/model/Food.dart';
import 'package:ordertakingapp/model/itemList.dart';
import 'package:ordertakingapp/model/itemListPDF.dart';
import 'package:ordertakingapp/screens/AllMenuList.dart';
import 'package:ordertakingapp/screens/FreeTablesScreen.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/LoginPref.dart';
import 'package:ordertakingapp/util/ToastUtil.dart';
import 'package:ordertakingapp/util/Util.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import 'LoginScreen.dart';
import 'SelectionScreen.dart';
import 'TablesClearScreen.dart';

class AdminMainPanelScreen extends StatefulWidget {
  @override
  _AdminMainPanelScreenState createState() => _AdminMainPanelScreenState();
}

class DefaultPageWidget extends StatelessWidget {
  final pw.Document pdf = pw.Document(deflate: zlib.encode);

  var totalSale;
  var totalDineInSale;
  var totalTakeAwaySale;
  var dummyList;

  String tSale;
  String tDineInSale;
  String tTakeawaySale;

  DefaultPageWidget(
      {this.totalSale,
      this.totalDineInSale,
      this.totalTakeAwaySale,
      this.dummyList});

  Future setData() async {
    tSale = "Total Sale" +
        "  \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t" +
        "(KR) ${totalSale}";
    tDineInSale = "Total DineIn Sale" +
        "   \t \t \t \t \t \t \t \t \t \t" +
        "(KR) ${totalDineInSale}";
    tTakeawaySale = "Total Takeaway Sale" +
        "  \t \t \t \t \t \t \t \t" +
        "(KR) ${totalTakeAwaySale}";
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: MyColors.mainColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Get.to(TablesClearScreen());
//          Util.navigateView(context, FreeTableScreen());
        },
        icon: Icon(
          Icons.offline_pin,
          size: 20.0,
          color: Colors.white,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 55.0),
        child: Text(
          "Admin",
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
              onTap: () {
                LoginPref.clearPreference();
                Util.pushAndRemoveUntil(context, SelectionScreen());
              },
              child: Center(
                  child: Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ))),
        ),
      ],
    );

    final body = SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: StatefulBuilder(builder: (context, setState1) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Sale",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "(KR) ${totalSale}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total DineIn Sale",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "(KR) ${totalDineInSale}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Takeaway Sale",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "(KR) ${totalTakeAwaySale}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Today Ordered Items",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                    color: MyColors.mainColor),
              ),
              SizedBox(
                height: 15.0,
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 15.0,
              ),
              (dummyList != null && dummyList.length > 0)
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: dummyList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          dummyList[index].name,
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          double.parse(dummyList[index]
                                                  .qty
                                                  .toString())
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Divider(
                                    height: 2.0,
                                    thickness: 2.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            );
                          }),
                    )
                  : Text("No items found"),
            ],
          );
        }),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            Util.navigateView(context, new AllMenuListScreen());
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: MyColors.mainColor,
          elevation: 4.0,
        ),
      ),
    );
  }
}

class CashPageWidget extends StatelessWidget {
  final pw.Document pdf = pw.Document(deflate: zlib.encode);

  var totalSale;
  var totalDineInSale;
  var totalTakeAwaySale;
  var totalCreditSale;
  var totalCashSale;
  var orderedCashItems1;
  var totalCashDineInSale;
  var totalCashTakeAwaySale;
  List<ItemList> dataList;

  String title;
  String tSale;
  String tDineInSale;
  String tTakeawaySale;
  String tSaleByCredit;
  String tSaleByCash;
  String todayOrderedItems;
  String tCashDineInSale;
  String tCashTakeawaySale;

  CashPageWidget(
      {this.totalSale,
      this.totalDineInSale,
      this.totalTakeAwaySale,
      this.totalCreditSale,
      this.totalCashSale,
      this.orderedCashItems1,
      this.totalCashDineInSale,
      this.totalCashTakeAwaySale,
      this.dataList});

  Future setData() async {
    title = " \t \t \t \t \t Naan Point";
    tSaleByCash = "Total Sale By Cash" +
        " \t \t \t \t \t \t \t \t \t \t" +
        "(KR) ${totalCashSale}";
    tCashDineInSale = "Total Cash DineIn Sale" +
        "   \t \t \t \t \t \t" +
        "(KR) ${totalCashDineInSale}";
    tCashTakeawaySale = "Total Cash Takeaway Sale" +
        "  \t \t \t \t" +
        "(KR) ${totalCashTakeAwaySale}";
    todayOrderedItems = "Today Ordered Items";
  }

  Future writeOnPDF(context) {
    pdf.addPage(
        pw.MultiPage(
        build: (context) => [
              _contentHeader(context),
              _generatePdfAndView(context),
      ]
        ));
  }

  pw.Widget _contentHeader(context) {
    return pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Expanded(
          flex: 2,
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(title,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 40.0, fontWeight: pw.FontWeight.bold, letterSpacing: 1.7, color:  PdfColors.orange)),
                pw.Divider(height: 10),
                pw.Text(tSaleByCash,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 20.0, letterSpacing: 1.7)),
                pw.Divider(height: 10),
                pw.Text(tCashDineInSale,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 1.7,
                    )),
                pw.Divider(height: 10),
                pw.Text(tCashTakeawaySale,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 1.7,
                    )),
                pw.Text(todayOrderedItems,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                      fontSize: 30.0,
                      letterSpacing: 1.7,
                    )),
              ]))
    ]);
  }

  pw.Widget _generatePdfAndView(context) {

    return pw.Table.fromTextArray(context: context, cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerRight
    }, data: <List<String>>[
      <String>['Name', 'Qty'],
      ...dataList.map((item) => [item.name, item.qty.toString()])
    ]);
  }


  Future savePdf(context) async {
    String documentPath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    print("getCurrentDate: " + Util.getCurrentDate());
    String pdfFileName = Util.getCurrentDate();
    File file =
        new File("$documentPath/" + "CashSalesReport_" + pdfFileName + ".pdf");

    file.writeAsBytesSync(pdf.save());

    ToastUtil.showToast(context, "file saved: " + documentPath);

    print(file);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: MyColors.mainColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Get.to(TablesClearScreen());
//          Util.navigateView(context, FreeTableScreen());
        },
        icon: Icon(
          Icons.offline_pin,
          size: 20.0,
          color: Colors.white,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 55.0),
        child: Text(
          "Admin",
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
              onTap: () {
                LoginPref.clearPreference();
                Util.pushAndRemoveUntil(context, SelectionScreen());
              },
              child: Center(
                  child: Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ))),
        ),
        IconButton(
          icon: Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
          ),
          onPressed: () async {
            await setData();
            await writeOnPDF(context);
            await savePdf(context);
            print("do something");
          },
        )
      ],
    );

    final body = SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: StatefulBuilder(builder: (context, setState1) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Sale By Cash",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "(KR) ${totalCashSale}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Cash DineIn Sale",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "(KR) ${totalCashDineInSale}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Cash Takeaway Sale",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "(KR) ${totalCashTakeAwaySale}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Today Ordered Items",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                    color: MyColors.mainColor),
              ),
              SizedBox(
                height: 15.0,
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 15.0,
              ),
              (orderedCashItems1 != null && orderedCashItems1.length > 0)
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: orderedCashItems1.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          orderedCashItems1[index].name,
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          double.parse(orderedCashItems1[index]
                                                  .qty
                                                  .toString())
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Divider(
                                    height: 2.0,
                                    thickness: 2.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            );
                          }),
                    )
                  : Text("No items found"),
            ],
          );
        }),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            Util.navigateView(context, new AllMenuListScreen());
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: MyColors.mainColor,
          elevation: 4.0,
        ),
      ),
    );
  }
}

class CreditPageWidget extends StatelessWidget {
  final pw.Document pdf = pw.Document(deflate: zlib.encode);

  var totalSale;
  var totalDineInSale;
  var totalTakeAwaySale;
  var totalCreditSale;
  var tax;
  var totalCashSale;
  var orderedCreditItems1;
  var totalCreditDineInSale;
  var totalCreditTakeAwaySale;
  List<ItemList> dataList;

  String title;
  String tSaleByCredit;
  String tTax;
  String tCreditDineInSale;
  String tCreditTakeawaySale;
  String todayOrderedItems;

  CreditPageWidget(
      {this.totalSale,
      this.totalDineInSale,
      this.totalTakeAwaySale,
      this.totalCreditSale,
      this.tax,
      this.totalCashSale,
      this.orderedCreditItems1,
      this.totalCreditDineInSale,
      this.totalCreditTakeAwaySale,
      this.dataList});

  Future setData() async {
    title = " \t \t \t \t \t Naan Point";
    tSaleByCredit = "Total Sale By Credit" +
        " \t \t \t \t \t \t \t \t \t " +
        "(KR) ${tax}";
    tTax = "Added Tax" +
        "  \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t " +
        "(KR) ${totalCreditSale * .25}";
    tCreditDineInSale = "Total Credit DineIn Sale" +
        "   \t \t \t \t \t " +
        "(KR) ${totalCreditDineInSale}";
    tCreditTakeawaySale = "Total Credit Takeaway Sale" +
        "  \t \t \t " +
        "(KR) ${totalCreditTakeAwaySale}";
    todayOrderedItems = "Today Ordered Items";
  }

  Future writeOnPDF(context) {
    pdf.addPage(
        pw.MultiPage(
        build: (context) => [
          _contentHeader(context),
          _generatePdfAndView(context),
        ],
            ));
  }

  pw.Widget _contentHeader(context) {
    return pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Expanded(
          flex: 2,
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(title,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 40.0, fontWeight: pw.FontWeight.bold, letterSpacing: 1.7, color:  PdfColors.orange)),
                pw.Divider(height: 10),
                pw.Text(tSaleByCredit,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 20.0, letterSpacing: 1.7)),
                pw.Divider(height: 10),
                pw.Text(tTax,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 20.0, letterSpacing: 1.7)),
                pw.Divider(height: 10),
                pw.Text(tCreditDineInSale,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 1.7,
                    )),
                pw.Divider(height: 10),
                pw.Text(tCreditTakeawaySale,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 1.7,
                    )),
                pw.Divider(height: 30),
                pw.Text(todayOrderedItems,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                      fontSize: 30.0,
                      letterSpacing: 1.7,
                    )),
              ]))
    ]);
  }

  pw.Widget _generatePdfAndView(context) {

    return pw.Table.fromTextArray(context: context, cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerRight
    }, data: <List<String>>[
      <String>['Name', 'Qty'],
      ...dataList.map((item) => [item.name, item.qty.toString()])
    ]);
  }

  Future savePdf(context) async {
    String documentPath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    print("getCurrentDate: " + Util.getCurrentDate());
    String pdfFileName = Util.getCurrentDate();
    File file =
        new File("$documentPath/" + "CreditSalesReport_" + pdfFileName + ".pdf");

    file.writeAsBytesSync(pdf.save());

    ToastUtil.showToast(context, "file saved: " + documentPath);

    print(file);
  }

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      backgroundColor: MyColors.mainColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Get.to(TablesClearScreen());
//          Util.navigateView(context, FreeTableScreen());
        },
        icon: Icon(
          Icons.offline_pin,
          size: 20.0,
          color: Colors.white,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 55.0),
        child: Text(
          "Admin",
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
              onTap: () {
                LoginPref.clearPreference();
                Util.pushAndRemoveUntil(context, SelectionScreen());
              },
              child: Center(
                  child: Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ))),
        ),
        IconButton(
          icon: Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
          ),
          onPressed: () async {
            await setData();
            await writeOnPDF(context);
            await savePdf(context);
            print("do something");
          },
        )
      ],
    );

    final body = SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: StatefulBuilder(builder: (context, setState1) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Sale By Credit",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "(KR) ${tax}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Added Tax",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "(KR) ${totalCreditSale * .25}",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Credit DineIn Sale",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "(KR) ${totalCreditDineInSale}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Credit TakeawaySale",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "(KR) ${totalCreditTakeAwaySale}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Today Ordered Items",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                    color: MyColors.mainColor),
              ),
              SizedBox(
                height: 15.0,
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 15.0,
              ),
              (orderedCreditItems1 != null && orderedCreditItems1.length > 0)
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: orderedCreditItems1.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          orderedCreditItems1[index].name,
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          double.parse(
                                                  orderedCreditItems1[index]
                                                      .qty
                                                      .toString())
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Divider(
                                    height: 2.0,
                                    thickness: 2.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            );
                          }),
                    )
                  : Text("No items found"),
            ],
          );
        }),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            Util.navigateView(context, new AllMenuListScreen());
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: MyColors.mainColor,
          elevation: 4.0,
        ),
      ),
    );
  }
}

class _AdminMainPanelScreenState extends State<AdminMainPanelScreen> {
  String tSale;
  String tDineInSale;
  String tTakeawaySale;
  String tSaleByCredit;
  String tSaleByCash;
  String todayOrderedItems;

  // Future setData() async {
  //   tSale = "Total Sale" +
  //       "  \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t" +
  //       "(KR) ${totalSale}";
  //   tDineInSale = "Total DineIn Sale" +
  //       "   \t \t \t \t \t \t \t \t \t \t" +
  //       "(KR) ${totalDineInSale}";
  //   tTakeawaySale = "Total Takeaway Sale" +
  //       "  \t \t \t \t \t \t \t \t" +
  //       "(KR) ${totalTakeAwaySale}";
  //   tSaleByCredit = "Total Sale By Credit" +
  //       " \t \t \t \t \t \t \t \t \t" +
  //       "(KR) ${totalCreditSale}";
  //   tSaleByCash = "Total Sale By Cash" +
  //       "  \t \t \t \t \t \t \t \t \t" +
  //       "(KR) ${totalCashSale}";
  //   todayOrderedItems = "\n \t \t \t \t \t Today Ordered Items";
  // }

  // final pw.Document pdf = pw.Document(deflate: zlib.encode);

  // pw.Widget _contentHeader(context) {
  //   return pw.Row(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         pw.Expanded(
  //             flex: 2,
  //             child: pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 children: [
  //                   pw.Text(
  //                       tSale,
  //                       style: pw.TextStyle(fontSize: 20.0, letterSpacing: 1.5)
  //                   ),
  //                   pw.Divider(height: 10),
  //                   pw.Text(
  //                       tDineInSale,
  //                       style: pw.TextStyle(fontSize: 20.0, letterSpacing: 1.5,)
  //                   ),
  //                   pw.Divider(height: 10),
  //                   pw.Text(
  //                       tTakeawaySale,
  //                       style: pw.TextStyle(fontSize: 20.0, letterSpacing: 1.5,)
  //                   ),
  //                   pw.Divider(height: 10),
  //                   pw.Text(
  //                       tSaleByCredit,
  //                       style: pw.TextStyle(fontSize: 20.0, letterSpacing: 1.5,)
  //                   ),
  //                   pw.Divider(height: 10),
  //                   pw.Text(
  //                       tSaleByCash,
  //                       style: pw.TextStyle(fontSize: 20.0, letterSpacing: 1.5,)
  //                   ),
  //                   pw.Divider(height: 10),
  //                 ]
  //             )
  //         )
  //       ]
  //   );
  // }


  pw.Widget _generatePdfAndView(context, List<ItemList> dataList) {
    List<ItemList> data = [
      ItemList(name: "item1", qty: "2"),
      ItemList(name: "item2", qty: "5"),
      ItemList(name: "item3", qty: "19")
    ];

    return pw.Table.fromTextArray(context: context, cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerRight
    }, data: <List<String>>[
      <String>['Name', 'Qty'],
      ...dataList.map((item) => [item.name, item.qty.toString()])
    ]);
  }

  // Future writeOnPDF(context) {
  //   pdf.addPage(
  //       pw.MultiPage(
  //           build: (context) =>
  //           [
  //             _contentHeader(context),
  //           ]
  //       )
  //   );
  // }

  // Future savePdf() async {
  //   String documentPath = await ExtStorage.getExternalStoragePublicDirectory(
  //       ExtStorage.DIRECTORY_DOWNLOADS);
  //
  //   print("getCurrentDate: " + Util.getCurrentDate());
  //   String pdfFileName = Util.getCurrentDate();
  //   File file = new File(
  //       "$documentPath/" + "SalesReport_" + pdfFileName + ".pdf");
  //
  //   file.writeAsBytesSync(pdf.save());
  //
  //   print(file);
  // }

  Stream dineInStream;
  Stream takeAwayStream;

  double totalSale = 0.0;
  double totalDineInSale = 0.0;
  double totalTakeAwaySale = 0.0;
  double addCreditTaxInTotalSale = 0.0;

  double totalCashSale = 0.0;
  double totalCashTakeAwaySale = 0.0;
  double totalCashDineInSale = 0.0;

  double totalCreditSale = 0.0;
  double totalCreditTakeAwaySale = 0.0;
  double totalCreditDineInSale = 0.0;
  int t;

  List<List<Food>> ORDERED_ITEMS = new List();
  List<List<Food>> ORDERED_ITEMS1 = new List();
  List<List<Food>> ORDERED_ITEMS2 = new List();

  List<ItemList> orderedCashItems1 = new List();
  List<double> cashDineInSale = new List();
  List<double> cashTakeAwaySale = new List();
  List<ItemList> dataListCash = new List();

  List<ItemList> orderedCreditItems1 = new List();
  List<double> creditDineInSale = new List();
  List<double> creditTakeAwaySale = new List();
  List<ItemList> dataListCredit = new List();

  List<double> dineInOrderTotal = new List();
  List<double> takeAwayOrderTotal = new List();
  List<double> cashOrderTotal = new List();
  List<double> creditOrderTotal = new List();

  FirebaseHandler _firebaseHandler = new FirebaseHandler();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Food> totalItems = new List();

  List<dummy> dummyList = new List();

  @override
  void initState() {
    super.initState();

    setState(() {
      ORDERED_ITEMS = new List();
      dummyList = new List();
      dataListCredit = new List();
      dataListCash = new List();
      t = -1;
    });

    _firebaseHandler
        .getDineInOrdersPaid(orderDate: Util.getCurrentDate())
        .then((val) {
      setState(() {
        dineInStream = val;

        dineInOrderTotal = null;

        totalDineInSale = 0.0;

        dineInStream.listen((data1) {
          print(data1.documents.length);
          getDineInTotalSale(data1);
        });
      });
    });
  }

//
//   @override
//   Widget build(BuildContext context) {
//     final appBar = AppBar(
//       backgroundColor: MyColors.mainColor,
//       elevation: 0,
//       centerTitle: true,
//       leading: IconButton(
//         onPressed: () {
//           Get.to(TablesClearScreen());
// //          Util.navigateView(context, FreeTableScreen());
//         },
//         icon: Icon(
//           Icons.offline_pin,
//           size: 20.0,
//           color: Colors.white,
//         ),
//       ),
//       title: Padding(
//         padding: const EdgeInsets.only(right: 55.0),
//         child: Text(
//           "Admin",
//           style: TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//               fontFamily: "Poppins",
//               fontWeight: FontWeight.w400),
//         ),
//       ),
//       actions: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(right: 10.0),
//           child: InkWell(
//               onTap: () {
//                 LoginPref.clearPreference();
//                 Util.pushAndRemoveUntil(context, SelectionScreen());
//               },
//               child: Center(
//                   child: Text(
//                     "Logout",
//                     style: TextStyle(fontSize: 20),
//                   ))),
//         ),
//         IconButton(
//           icon: Icon(
//             Icons.save,
//             color: Colors.white,
//           ),
//           onPressed: () async {
//             await setData();
//             await writeOnPDF(context);
//             await savePdf();
//             print("do something");
//           },
//         )
//       ],
//     );
//
//     final body = SafeArea(
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
//         child: StatefulBuilder(builder: (context, setState1) {
//           return Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     "Total Sale",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                   Text(
//                     "(KR) ${totalSale}",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     "Total DineIn Sale",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   Text(
//                     "(KR) ${totalDineInSale}",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   Text(
//                     "(KR) ${totalDineInSale}",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     "Total Takeaway Sale",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   Text(
//                     "(KR) ${totalTakeAwaySale}",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     "Total Sale By Credit",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   Text(
//                     "(KR) ${totalCreditSale}",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     "Total Sale By Cash",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   Text(
//                     "(KR) ${totalCashSale}",
//                     style:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Divider(
//                 height: 1.0,
//                 thickness: 1.0,
//                 color: Colors.grey,
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Text(
//                 "Today Ordered Items",
//                 style: TextStyle(
//                     fontSize: 30.0,
//                     fontWeight: FontWeight.w600,
//                     color: MyColors.mainColor),
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Divider(
//                 height: 1.0,
//                 thickness: 1.0,
//                 color: Colors.grey,
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               (dummyList != null && dummyList.length > 0)
//                   ? Expanded(
//                 child: ListView.builder(
//                     itemCount: dummyList.length,
//                     shrinkWrap: true,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 5.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             SizedBox(height: 10.0,),
//
//                             Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     dummyList[index].name,
//                                     style: TextStyle(
//
//                                         fontSize: 19.0,
//                                         fontWeight: FontWeight.w600
//                                     ),),),
//
//                                 Expanded(
//                                   flex: 1,
//                                   child: Text(double.parse(
//                                       dummyList[index].qty.toString())
//                                       .toString(),
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontSize: 22.0,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.green
//                                     ),),),
//                               ],
//                             ),
//
//                             SizedBox(height: 10.0,),
//
//                             Divider(height: 2.0,
//                               thickness: 2.0,
//                               color: Colors.black,),
//                           ],
//                         ),
//                       );
//                     }),
//               )
//                   : Text("No items found"),
//             ],
//           );
//         }),
//       ),
//     );
//
//     return Scaffold(
//       appBar: appBar,
//       body: body,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
//         child: FloatingActionButton(
//           onPressed: () {
//             Util.navigateView(context, new AllMenuListScreen());
//           },
//           child: Icon(
//             Icons.add,
//             color: Colors.white,
//           ),
//            backgroundColor: MyColors.mainColor,
//           elevation: 4.0,
//        ),
//       ),
//     );
//   }

  getAllOrderedItems(snapshot1) {
    ORDERED_ITEMS1 = new List();

    if (snapshot1.documents != null && snapshot1.documents.length > 0) {
      print(snapshot1.documents.length);

      for (int loop = 0; loop < snapshot1.documents.length; loop++) {
        List<Food> data =
            snapshot1.documents[loop].data["orderedItems"].map<Food>((item) {
//          print(item);

          var xx = Food.fromJson(item);

          return xx;
        }).toList();

        ORDERED_ITEMS1.add(data);
      }
    }
  }

  HashMap hashMap = new HashMap<String, int>();



  getDineInTotalSale(snapshot1) {
    hashMap = new HashMap<String, int>();

    dineInOrderTotal = new List();
    takeAwayOrderTotal = new List();
    cashOrderTotal = new List();
    creditOrderTotal = new List();
    cashDineInSale = new List();
    cashTakeAwaySale = new List();
    creditDineInSale = new List();
    creditTakeAwaySale = new List();

    if (snapshot1.documents != null && snapshot1.documents.length > 0) {
      for (int loop = 0; loop < snapshot1.documents.length; loop++) {
        double total = 0.0;

        String type = snapshot1.documents[loop].data["orderType"];

        // Added here
        String paidByType = snapshot1.documents[loop].data["paidBy"];

        total = double.parse(snapshot1.documents[loop].data["orderTotal"]);

        print(type);
        print("paidByType: " + paidByType);

        t++;

        if (type == "Take Away") {
          takeAwayOrderTotal.add(total);

          if (paidByType == "CASH") {
            if ("${type}" == "Dine In" && "${paidByType}" == "CASH") {
              print("paidByType == Cash and type == Take Away => True: " +
                  total.toString());
              cashDineInSale.add(total);
            } else {
              print("paidByType == Cash and type == Take Away => True: " +
                  total.toString());
              cashTakeAwaySale.add(total);
            }
            cashOrderTotal.add(total);
            List<Food> data =
                snapshot1.documents[loop].data["orderedItems"].map<Food>((item) {
              print("value of t: " + t.toString());
              print("CashOrderedItems" + item.toString());

              var xx = Food.fromJson(item);

              return xx;
            }).toList();

            orderedCashItems1.addAll(
                data.map((e) => ItemList(name: e.name, qty: e.qty.toString())));

            String xName;
            dataListCash.addAll(
                data.map((e) {
                  xName = e.name.replaceAll(RegExp(r"[^\s\w]"), "");
                  print("xName: " + xName);
                  return ItemList(name: xName, qty: e.qty.toString());
                }));
          } else {
            creditOrderTotal.add(total);

            if ("${type}" == "Dine In" && "${paidByType}" == "CREDIT") {
              print("paidByType == Credit and type == Take Away => True: " +
                  total.toString());
              creditDineInSale.add(total);
            } else {
              print("paidByType == Credit and type == Take Away => False: " +
                  total.toString());
              creditTakeAwaySale.add(total);
            }
            List<Food> data =
                snapshot1.documents[loop].data["orderedItems"].map<Food>((item) {
              print("value of t: " + t.toString());
              print("CreditOrderedItem: " + item.toString());

              var xx = Food.fromJson(item);

              return xx;
            }).toList();

            orderedCreditItems1.addAll(
                data.map((e) => ItemList(name: e.name, qty: e.qty.toString())));

            String xName;
            dataListCredit.addAll(
                data.map((e) {
                  xName = e.name.replaceAll(RegExp(r"[^\s\w]"), "");
                  print("xName: " + xName);
                  return ItemList(name: xName, qty: e.qty.toString());
                }));
          }
        }
        else {
          dineInOrderTotal.add(total);

          if (paidByType == "Cash") {
            if ("${type}" == "Take Away" && "${paidByType}" == "CASH") {
              print("paidByType == Cash and type == Take Away => True: " +
                  total.toString());
              cashTakeAwaySale.add(total);
            } else {
              print("paidByType == Cash and type == Take Away => True: " +
                  total.toString());
              cashDineInSale.add(total);
            }
            cashOrderTotal.add(total);

            List<Food> data =
                snapshot1.documents[loop].data["orderedItems"].map<Food>((item) {
              print("value of t: " + t.toString());
              print("CashOrderedItems" + item.toString());

              var xx = Food.fromJson(item);

              return xx;
            }).toList();

            orderedCashItems1.addAll(
                data.map((e) => ItemList(name: e.name, qty: e.qty.toString())));
          } else {
            if ("${type}" == "Take Away" && "${paidByType}" == "CREDIT") {
              print("paidByType == Credit and type == Take Away => True: " +
                  total.toString());
              creditTakeAwaySale.add(total);
            } else {
              print("paidByType == Credit and type == Take Away => False: " +
                  total.toString());
              creditDineInSale.add(total);
            }
            creditOrderTotal.add(total);
            List<Food> data =
                snapshot1.documents[loop].data["orderedItems"].map<Food>((item) {
              print("value of t: " + t.toString());
              print("CreditOrderedItem: " + item.toString());

              var xx = Food.fromJson(item);

              return xx;
            }).toList();

            orderedCreditItems1.addAll(
                data.map((e) => ItemList(name: e.name, qty: e.qty.toString())));
          }
        }

        List<Food> orderedItems =
            snapshot1.documents[loop].data["orderedItems"].map<Food>((item) {
          return Food.fromJson(item);
        }).toList();

        // String xName;
        // for (int x = 0; x < orderedItems.length; x++) {
        //   xName = orderedItems[x].name.replaceAll(RegExp(r"[^\s\w]"), "");
        //   print("xName: " + xName);
        //   dataList.add(ItemList(name: xName, qty: orderedItems[x].qty.toString()));
        // }
        // print("dataList Started: " + dataList[0].name);

        for (int x = 0; x < orderedItems.length; x++) {
          if (hashMap.containsKey(orderedItems[x].name)) {
            int oldQty = hashMap[orderedItems[x].name];
            int newQty = orderedItems[x].qty;

            int finalQty = oldQty + newQty;

            hashMap.update(orderedItems[x].name, (e) => finalQty);

            setState(() {});
          } else {
            hashMap.putIfAbsent(
                orderedItems[x].name, () => orderedItems[x].qty);

            setState(() {});
          }
        }
      }

      hashMap.forEach((key, value) {
        print('key: $key, value: $value');
        dummyList.add(new dummy.name(key, value));
      });

      var tCashSale = 0.0;
      for (int x = 0; x < cashOrderTotal.length; x++) {
        tCashSale += cashOrderTotal[x];
        print(tCashSale);
      }

      var tCashDineInSale = 0.0;
      for (int x = 0; x < cashDineInSale.length; x++) {
        tCashDineInSale += cashDineInSale[x];
        print(tCashDineInSale);
      }

      var tCashTakeAwaySale = 0.0;
      for (int x = 0; x < cashTakeAwaySale.length; x++) {
        tCashTakeAwaySale += cashTakeAwaySale[x];
        print(tCashTakeAwaySale);
      }

      var tCreditSale = 0.0;
      for (int x = 0; x < creditOrderTotal.length; x++) {
        tCreditSale += creditOrderTotal[x];
        print(tCreditSale);
      }

      var tCreditTakeAwaySale = 0.0;
      for (int x = 0; x < creditTakeAwaySale.length; x++) {
        tCreditTakeAwaySale += creditTakeAwaySale[x];
        print(tCreditTakeAwaySale);
      }

      var tCreditDineInSale = 0.0;
      for (int x = 0; x < creditDineInSale.length; x++) {
        tCreditDineInSale += creditDineInSale[x];
        print(tCreditDineInSale);
      }

      var pricee = 0.0;
      for (int x = 0; x < dineInOrderTotal.length; x++) {
        pricee += dineInOrderTotal[x];
        print(pricee);
      }

      var pricee2 = 0.0;
      for (int x = 0; x < takeAwayOrderTotal.length; x++) {
        pricee2 += takeAwayOrderTotal[x];
        print(pricee2);
      }
      setState(() {
        totalDineInSale = pricee;
        totalTakeAwaySale = pricee2;

        totalCashSale = tCashSale;
        totalCashDineInSale = tCashDineInSale;
        totalCashTakeAwaySale = tCashTakeAwaySale;

        totalCreditSale = tCreditSale;
        totalCreditDineInSale = tCreditDineInSale;
        totalCreditTakeAwaySale = tCreditTakeAwaySale;

        totalSale = totalTakeAwaySale + totalDineInSale;

        print("totalCashSale: " + totalCashSale.toString());
        print("totalCreditSale: " + totalCreditSale.toString());
      });
    }
  }

  List<dummy> temp = new List();

  populateItems() {
    if (ORDERED_ITEMS1.length > 0) {
      for (int x = 0; x < ORDERED_ITEMS1.length; x++) {
        print("ORDERED_ITEMS1 ${ORDERED_ITEMS1.length}");

        List<Food> list = ORDERED_ITEMS1[x];

        print("list ${list.length}");

        for (int y = 0; y < list.length; y++) {
          if (temp.length > 0) {
            for (int xx = 0; xx < temp.length; xx++) {
              if (temp[xx].name == list[y].name) {
                temp[xx].qty = temp[xx].qty + list[y].qty;
              }

              temp.add(dummy.name(list[y].name, list[y].qty));
            }
          } else {
            setState(() {
              temp.add(dummy.name(list[y].name, list[y].qty));
            });
          }
        }
      }

      for (int xxx = 0; xxx < temp.length; xxx++) {
        print("${temp[xxx].name} ${temp[xxx].qty}");
      }
    }
  }

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tax;

    tax  = totalCreditSale * .25;
    tax = totalCreditSale + tax;
    print("tax: " + tax.toString());

    if(totalCreditSale > 0) {
      addCreditTaxInTotalSale = totalSale + (totalCreditSale * .25);
      print("addCreditTaxInTotalSale: " + addCreditTaxInTotalSale.toString());
      print("TotalSale: " + totalSale.toString());
    } else {
      addCreditTaxInTotalSale = totalSale;
    }

    return PageView(
      controller: _controller,
      children: [
        DefaultPageWidget(

            totalSale: addCreditTaxInTotalSale,
            totalDineInSale: totalDineInSale,
            totalTakeAwaySale: totalTakeAwaySale,
            dummyList: dummyList),
        CashPageWidget(
            totalSale: totalSale,
            totalDineInSale: totalDineInSale,
            totalTakeAwaySale: totalTakeAwaySale,
            totalCreditSale: totalCreditSale,
            totalCashSale: totalCashSale,
            orderedCashItems1: orderedCashItems1,
            totalCashDineInSale: totalCashDineInSale,
            totalCashTakeAwaySale: totalCashTakeAwaySale,
            dataList: dataListCash),

        CreditPageWidget(
            totalSale: totalSale,
            totalDineInSale: totalDineInSale,
            totalTakeAwaySale: totalTakeAwaySale,
            totalCreditSale: totalCreditSale,
            tax: tax,
            totalCashSale: totalCashSale,
            orderedCreditItems1: orderedCreditItems1,
            totalCreditDineInSale: totalCreditDineInSale,
            totalCreditTakeAwaySale: totalCreditTakeAwaySale,
            dataList: dataListCredit)
      ],
    );
  }
}

/*
 if ( dummyList.length == 0 ) {
            setState(() {
              dummyList.add(new dummy.name(list[y].name, list[y].qty));
            });
            continue;
          }
          for (int loop = 0; loop < dummyList.length; loop++) {
            if (dummyList[loop].name == list[y].name) {
              setState(() {
                dummyList[loop].qty = dummyList[loop].qty + list[y].qty;
              });
            } else {
              setState(() {
                dummyList.add(new dummy.name(list[y].name, list[y].qty));
              });
            }
          }
 */
