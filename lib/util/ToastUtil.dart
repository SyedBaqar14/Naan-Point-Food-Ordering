import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ToastUtil {
  static void showToast(BuildContext context, String msg) {
    print("msg " + msg);

    if (msg == null) {
      return;
    }
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  static void showSnackBar(BuildContext context,String msg){

    final snackBar = SnackBar(content: Text(msg!=null?msg:""));
    ScaffoldState().showSnackBar(snackBar);


  }
}
