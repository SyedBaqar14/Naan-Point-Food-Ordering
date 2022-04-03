import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ordertakingapp/firebasehelper/FirebaseHandler.dart';
import 'package:ordertakingapp/model/Food.dart';
import 'package:ordertakingapp/util/Colors.dart';
import 'package:ordertakingapp/util/ToastUtil.dart';
import 'package:ordertakingapp/util/Util.dart';
import 'package:ordertakingapp/widgets/button.dart';
import 'package:random_string/random_string.dart';

class AddMenuScreen extends StatefulWidget {

  String id;
  String name;
  String image;
  double price;

  bool isUpdate = false;

  AddMenuScreen({this.id, this.name, this.image, this.price, this.isUpdate});
  @override
  _AddMenuScreenState createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {

  TextEditingController foodNameController = new TextEditingController();
  TextEditingController foodPriceController = new TextEditingController();

  File _image;

  final picker = ImagePicker();

  String buttonTitle = "Save";

  String foodID = "";

  String imagePath = "";

  String pageTitle = "Create Menu";

  FirebaseHandler _firebaseHandler = new FirebaseHandler();

  void pickImageFromGallery( ImageSource source) async{
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      _image = File(pickedFile.path);
    });
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      if(widget.isUpdate){
        buttonTitle = "Update";

        pageTitle = "Update Menu";

        foodID = widget.id;

        imagePath = widget.image;

        print(imagePath);

        _image = File(imagePath);

        foodNameController.text = widget.name;
        foodPriceController.text = widget.price.toString();

      }else{
        buttonTitle = "Save";

        pageTitle = "Create Menu";
      }
    });
  }

  Future<String> createFoodItem(BuildContext context, String name, String price) async {

    try {
      Util.showLoader(context);

      if(widget.isUpdate){

      }else{
        String fileName = _image.path.split('/').last;

        StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName);
        StorageUploadTask uploadTask = reference.putFile(_image);

        print("Image PATH==== ${_image.path.toString()}");

        StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);

        imagePath = (await downloadUrl.ref.getDownloadURL());

        print(imagePath);

        foodID = randomAlphaNumeric(16);
      }

      var foodData = new Food(id: foodID, name: name, price: double.parse(price), image: imagePath,qty: 1);

      _firebaseHandler.addFoodData(foodData, foodID).then((value)
          {
        ToastUtil.showToast(context, "Food Item created successfully");
        Util.hideLoader(context);

        Navigator.of(context).pop();
      });
    }catch(e){
      print(e);
    }
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
        pageTitle,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400
        ),
      ),
    );

    final foodName = TextFormField(
      controller: foodNameController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: decoration("Food Name"),
    );

    final foodPrice = TextFormField(
      controller: foodPriceController,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: decoration("Food Price"),
    );

    final imagePickerBox = Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.mainColor, width: 1.5),
        image: DecorationImage(
          image: new ExactAssetImage("assets/images/ic_upload_placeholder.png"),
            fit: BoxFit.cover,
        ),
      ),
        child:  (widget.isUpdate) ? Image.network(imagePath,fit: BoxFit.cover,) : (_image == null ) ? Container() : Image.file(_image, fit: BoxFit.cover,),
//      child:
    );

    final body = SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              SizedBox(height: 50.0,),

              GestureDetector(
                onTap: (){
                  if(widget.isUpdate){
                  }else{
                    pickImageFromGallery(ImageSource.gallery);
                  }
                },
                  child: imagePickerBox),

              SizedBox(height: 5.0,),

              Text("Click to select image", style: TextStyle(fontSize: 12.0, fontFamily: "Poppins", fontWeight: FontWeight.w200),),

              SizedBox(height: 40.0,),

              foodName,

              SizedBox(height: 20.0,),

              foodPrice,

              SizedBox(height: 40.0,),

              GestureDetector(
                onTap: (){
                  String name = foodNameController.text.trim().toString();
                  String price = foodPriceController.text.toString();

//                String imagePath = _image.path;

                  if(validateData(name, price, _image)){
                    createFoodItem(context, name, price.toString());
                  }
                },
                  child: Button(title: buttonTitle,)),

            ],
          ),
        ),
      ),
    );

    return Scaffold(
     
      backgroundColor: Colors.white,
        appBar: appBar,
      body: body,
    );
  }

  bool validateData(String name, String price, File imagePath){
    if(name.isEmpty){
        ToastUtil.showToast(context, "Must enter food item name");
        return false;
    }

    if(price.toString().isEmpty){
      ToastUtil.showToast(context, "Must enter food item price");
      return false;
    }

      double varr = double.parse(price);
    if(varr == 0.0 || varr < 0){
      ToastUtil.showToast(context, "Must enter food item price greater than 0");
      return false;
    }

    if(imagePath == null){
      ToastUtil.showToast(context, "Must select food item image");
      return false;
    }

    if(imagePath.path.toString().isEmpty){
      ToastUtil.showToast(context, "Must select food item image");
      return false;
    }

    return true;
  }

  InputDecoration decoration(String title) {
    return InputDecoration(
      hintText: title,
      hintStyle: TextStyle(
          fontSize: 15.0,
          fontFamily: 'Poppins-Regular',
          color: const Color(0xff94A5A6)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0),
        borderSide:
        const BorderSide(color: const Color(0xFFf36408), width: 1.3),
      ),
      contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0),
        borderSide:
        const BorderSide(color:  Color(0xFFf36408), width: 1.3),
      ),
    );
  }

}
