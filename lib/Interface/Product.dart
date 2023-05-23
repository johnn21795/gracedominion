
import 'dart:async';
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Classes/LogicClass.dart';
import '../Classes/TableClass.dart';
import '../Desktop/WidgetClass.dart';
import 'package:file_picker/file_picker.dart';

import 'MainInterface.dart';

Size? screenSize;
class ProductPage extends StatefulWidget {
  final Map<String, dynamic> data;
  // final Function() myFunction;
  // const ProductPage({Key? key, required this.data, required this.myFunction}) : super(key: key);
  const ProductPage({Key? key, required this.data}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  @override
  void dispose(){
    super.dispose();
  }
  bool isEditing = false;
  bool updateImage = false;
  bool newProduct = false;
  bool processingImage = false;
  final nameController = TextEditingController();
  final modelController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final commentController = TextEditingController();
  final List<FocusNode> focusNode = List.generate(3, (index) => FocusNode());
  Map<String, dynamic> productData = {};



  Color labelColor = WidgetClass.mainColor;
  String? imagePath;
  List<File?> files = [];

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    );
    if (result != null) {
      processingImage = true;
      setState(() {

      });
      PlatformFile file = result.files.first;
      String filePath = file.path!;
      files = await CalculateClass().selectImage(filePath);
      // Use the selected file path for further processing
      processingImage = false;
      updateImage = true;
      setState(() {
        imagePath = file.path!;
      });
      print(filePath);
    } else {
      // User canceled the file picking operation
      print('No image file selected.');
    }
  }



  @override
  void initState() {

    // pageLoading = false;
    if(widget.data["Name"] == "" && widget.data["Model"] == ""){
      isEditing = true;
      newProduct = true;
    }
    productData["Name"] = widget.data["Name"];
    productData["Model"] = widget.data["Model"];
    productData["Category"] =widget.data["Category"];
    productData["Quantity"] = widget.data["Quantity"];
    productData["Comment"] =widget.data["Comment"];
    productData["ProductID"] = widget.data["ProductID"];
    productData["Image"] = InventoryImage(productId:  productData["ProductID"], imageType: "Images");
    // WidgetsBinding.instance.addPostFrameCallback((_) { changeActivePage();});
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;
    return  Scaffold(
      body:  Stack(
        children: [
          Positioned(
            top: 30,
            right:15,

            child: SizedBox(
                width: screenSize!.width * 0.5,
                height: screenSize!.height * 0.87,
                child: TableClass(tableColumns: {"No" :ColumnSize.S, "Date" :ColumnSize.S, "Customer":ColumnSize.M,"Previous":ColumnSize.S,"Sold":ColumnSize.S,"Balance":ColumnSize.S}, tableName: "Product:${productData["ProductID"]}", myFunction: (){})
            ),
          ),
          Positioned(
              top:5,
              left: screenSize!.width * 0.43,
              child: SizedBox(
                  child: Text("Product History", style: TextStyle(fontFamily: "Claredon", fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.022),))
          ),

          Positioned(
              top:5,
              left: screenSize!.width * 0.02,
              child: SizedBox(
                  child: Text("Add Product", style: TextStyle(fontFamily: "Claredon", fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.022),))
          ),
          Positioned(
              top:screenSize!.height * 0.035,
              left: screenSize!.width * 0.02,
              child: Container(
                  width: screenSize!.width * 0.12,
                  height: screenSize!.width * 0.12,
                  decoration: BoxDecoration(
                      border: Border.all(color: WidgetClass.mainColor, width: 1.5, strokeAlign: BorderSide.strokeAlignCenter),
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child:processingImage ? Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                    child: Container(
                      transform: Matrix4.translationValues(10, 5, 0),
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black38,
                        strokeWidth: 5.0,
                        color: mainColor,
                      ),
                    ),
                  ):  imagePath != null?
                  Image.file(files[1]!,fit: BoxFit.cover,):
                  productData["Image"]
                  // const Image(
                  //   image: AssetImage('assets/images/placeholder.jpg'),
                  //   fit: BoxFit.cover,
                  // )
              )
          ),
          Positioned(
            top: screenSize!.height * 0.05,
            left: screenSize!.width * 0.15,
            child: SizedBox(
              width: screenSize!.width * 0.32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product ID:",
                    style: TextStyle(fontFamily: "Claredon",fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.022,),
                  ),
                  Text(
                    productData["ProductID"].toString().contains("Error")? "No Internet":   productData["ProductID"],
                    style: TextStyle(fontFamily: "Claredon",fontSize: screenSize!.height * 0.022, color:  productData["ProductID"].toString().contains("Error")? Colors.red[800] : Colors.black ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: screenSize!.height * 0.15,
              left: screenSize!.width * 0.15,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyCustomButton(
                      text: "Choose Image",
                      onPressed: pickFile,
                      icon: FontAwesomeIcons.fileImage,
                      size:  const Size(128,35)
                  ),
                  const SizedBox(height: 10,),
                  Visibility(
                    visible: !newProduct ? isEditing ? true : false: false,
                    child: Row(
                      children: [
                         Text('Update Image $updateImage', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                        StatefulBuilder(builder: (context, setState){
                          return  Center(
                            child:  Switch(
                                activeColor: mainColor,
                                value: updateImage,
                                onChanged: (value) {
                                  updateImage = !updateImage;
                                  setState((){});
                                  // Do something when the switch button is toggled.
                                },
                              ),
                          );}),
                        //,
                      ],
                    ),
                  ),
                ],
              )
          ),
          Positioned(
            top: screenSize!.height * 0.28,
            left: screenSize!.width * 0.018,
            child: SizedBox(
              width: screenSize!.width * 0.30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name:",
                    style: TextStyle(fontFamily: "Claredon",fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.022,),
                  ),
                  isEditing? SizedBox(
                      width:  screenSize!.width * 0.32,
                      child: TextField(
                        focusNode: focusNode[0],
                        style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                        controller: nameController,
                        decoration:  InputDecoration(
                            errorStyle: const TextStyle(color: Colors.red),
                            // errorText: nameController.text.isEmpty ? 'Field cannot be empty' : null,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: labelColor, width: 2.0),
                          ),
                          suffixIcon: Icon(Icons.edit, color: mainColor,)),

                      )):
                  Text(
                    productData["Name"],
                    style: TextStyle(
                      fontFamily: "Claredon",
                      fontSize: screenSize!.height * 0.022,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenSize!.height * 0.39,
            left: screenSize!.width * 0.018,
            child: SizedBox(
              width: screenSize!.width * 0.30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Model:",
                    style: TextStyle(fontFamily: "Claredon",fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.022,),
                  ),
              isEditing? SizedBox(
                  width:  screenSize!.width * 0.35,
                  child: TextField(
                style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                controller: modelController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    suffixIcon:  Icon(Icons.edit, color: mainColor,)),
              )):
                  Text(
                    productData["Model"],
                    style: TextStyle(
                      fontFamily: "Claredon",
                      fontSize: screenSize!.height * 0.022,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenSize!.height * 0.50,
            left: screenSize!.width * 0.018,
            child: SizedBox(
              width: screenSize!.width * 0.30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category:",
                    style: TextStyle(fontFamily: "Claredon",fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.022,),
                  ),
                  isEditing? SizedBox(
                      width:  screenSize!.width * 0.32,
                      child: TextField(
                        focusNode: focusNode[1],
                        style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                        controller: categoryController,
                        decoration:  InputDecoration(
                            errorStyle: const TextStyle(color: Colors.red),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: labelColor, width: 2.0),
                          ),
                          suffixIcon:  Icon(Icons.edit, color: WidgetClass.mainColor,)),
                      )):Text(
                    productData["Category"],
                    style: TextStyle(
                      fontFamily: "Claredon",
                      fontSize: screenSize!.height * 0.022,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenSize!.height * 0.61,
            left: screenSize!.width * 0.018,
            child: SizedBox(
              width: screenSize!.width * 0.30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quantity:",
                    style: TextStyle(fontFamily: "Claredon",fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.022,),
                  ),
                  isEditing && newProduct?  SizedBox(
                      width:  screenSize!.width * 0.32,
                      child: TextField(
                        focusNode: focusNode[2],
                        style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                        controller: quantityController,
                        decoration:  InputDecoration(
                            errorStyle: const TextStyle(color: Colors.red),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: labelColor, width: 2.0),
                            ),
                            suffixIcon:  Icon(Icons.edit, color: WidgetClass.mainColor,)),
                      )):
                  Text(
                    productData["Quantity"],
                    style: TextStyle(
                      fontFamily: "Claredon",
                      fontSize: screenSize!.height * 0.022,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenSize!.height * 0.71,
            left: screenSize!.width * 0.018,
            child: SizedBox(
              width: screenSize!.width * 0.30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Comment:",
                    style: TextStyle(fontFamily: "Claredon",fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.022,),
                  ),
                  isEditing? SizedBox(
                      width:  screenSize!.width * 0.32,
                      child: TextField(
                        onSubmitted: (query){},
                        style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                        controller: commentController,
                        decoration:  InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: labelColor, width: 2.0),
                            ),
                            suffixIcon:  Icon(Icons.edit, color: WidgetClass.mainColor,)),
                      )):Text(
                    productData["Comment"],
                    style: TextStyle(
                      fontFamily: "Claredon",
                      fontSize: screenSize!.height * 0.022,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom:15,
              left: screenSize!.width * 0.02,
              child:MyCustomButton(
                  text:isEditing? !newProduct ?"Update Product": "Save Product" :newProduct ? "Add Product": "Edit Product",
                  onPressed: () async{
                    if(!newProduct && !isEditing){
                      nameController.text = productData["Name"];
                      modelController.text = productData["Model"];
                      categoryController.text = productData["Category"];
                      commentController.text = productData["Comment"];
                      nameController.text = productData["Name"];
                    }
                    if(isEditing){
                     var x =  await checkDuplicateName(context);
                     print('Check Duplicate X $x');
                     if(!x!){
                       await saveProductDialog(context);
                     }else{
                       SnackBar snackBar = SnackBar(backgroundColor: Colors.black87, content: Text("Duplicate Product Name", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white), ), duration:const Duration(milliseconds: 2000) ,);
                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                       FocusScope.of(context).requestFocus(focusNode[0]);
                     }
                    }else{
                      isEditing = true;
                    }

                    setState(() {

                    });
                  },
                  icon:isEditing? FontAwesomeIcons.floppyDisk : newProduct ?FontAwesomeIcons.plus : FontAwesomeIcons.penToSquare,
                  size:  const Size(170,40)
              )
          ),
          Positioned(
              bottom:20,
              left: screenSize!.width * 0.2,
              child:
              Visibility(
                visible: isEditing,
                child: TextButton.icon(onPressed: () {
                  isEditing = false;
                  setState(() {});
                }, icon:  Icon(Icons.cancel, color: Colors.red[800], ),
                label: const Text("Cancel"),
             ),
              ),

          ),





        ]
        ,
      )
      ,
    );
  }

  Future<bool?> checkDuplicateName(BuildContext context) async {
    if(!newProduct){
      return false;
    }
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: isEditing,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final dialog =  AlertDialog(
                title: const Text('Connecting...'),
                content:  Padding( padding: const
                EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                  child: Container(
                    transform: Matrix4.translationValues(10, 5, 0),
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      color:mainColor,
                    ),
                  ),
                )

            );
            Future.delayed(const Duration(milliseconds: 2000), () async {
              var x = await FirebaseClass.getProductName(nameController.text);
               Navigator.of(context).pop(x);
            });
            return dialog;
          },
        );},);
  }

  Future<bool?> saveProductDialog(BuildContext context) async {
   // Add this variable to track the editing state
    if (nameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(focusNode[0]);
      return null;
    }
    if (categoryController.text.isEmpty) {
      FocusScope.of(context).requestFocus(focusNode[1]);
      return null;
    }
    if(newProduct){
      if (quantityController.text.isEmpty) {
        FocusScope.of(context).requestFocus(focusNode[2]);
        return null;
      }
    }
    if(newProduct){
      try{
        int.parse(quantityController.text);
      }catch(e){
        FocusScope.of(context).requestFocus(focusNode[2]);
        return null;
      }
    }


    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: isEditing,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(

              title: newProduct? const Text('Save Product') :  const Text('Update Product'),
              content: !isEditing
                  ? Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                child: Container(
                  transform: Matrix4.translationValues(10, 5, 0),
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                    color: mainColor,
                  ),
                ),
              )
                  :  Text('Confirm ${newProduct? 'Save':'Update'} Product: \n${ widget.data["Name"]}'),
              actions: [
                TextButton(
                  onPressed: () {
                    // User clicked on the Cancel button
                    isEditing = true;
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    isEditing = false;
                    setState((){});
                    if(newProduct){
                      var success = await createNewProduct(files.isNotEmpty);
                      String snack = success? "Product Added Successfully!" : "Failed to Add Product";
                      SnackBar snackBar = SnackBar(backgroundColor: Colors.black87, content: Text(snack, style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,);
                      Navigator.of(context).pop(false);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }else{
                      var success = await updateProduct(files.isNotEmpty && updateImage);
                      String snack = success? "Product Updated Successfully!" : "Failed to Update Product";
                      SnackBar snackBar = SnackBar(backgroundColor: Colors.black87, content: Text(snack, style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,);
                      Navigator.of(context).pop(false);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> updateProduct(bool updateImage) async{
    productData["Name"] = nameController.text.trim().toUpperCase().replaceAll("  ", " ");
    productData["Model"] = modelController.text.trim().toUpperCase();
    productData["Category"] = categoryController.text.trim().toUpperCase();
    productData["Comment"] = commentController.text.trim().toUpperCase();
    productData["NameList"] = productData["Name"].toString().split(' ');
    if(updateImage) {
      productData["Thumbnail"] = files[0];
      productData["Image"] = files[1];
    }else{
      productData.remove("Thumbnail");
      productData.remove("Image");
    }
    var success = await FirebaseClass.updateProduct(productData);
    if(updateImage) {
      try {
        final String? userProfile = Platform.environment['USERPROFILE'];
        String imageFolderPath = '$userProfile\\AppData\\Local\\CachedImages\\Thumbnails';
        File imageFile = File('$imageFolderPath\\${productData["ProductID"]}.jpg');
        imageFile.deleteSync();
        imageFolderPath = '$userProfile\\AppData\\Local\\CachedImages\\Images';
        imageFile = File('$imageFolderPath\\${productData["ProductID"]}.jpg');
        imageFile.deleteSync();
      } catch (e) {
        print(e);
      }
    }
    InventoryImage(productId:  productData["ProductID"], imageType: "Thumbnail");
    productData["Image"] = InventoryImage(productId:  productData["ProductID"], imageType: "Images");
    return success;
    }

  Future<bool> createNewProduct(bool hasImage) async {
    productData["Name"] = nameController.text.trim().toUpperCase().replaceAll("  ", " ");
    productData["Model"] = modelController.text.trim().toUpperCase();
    productData["Category"] = categoryController.text.trim().toUpperCase();
    productData["Quantity"] = quantityController.text;
    productData["Comment"] = commentController.text.trim().toUpperCase();
    productData["NameList"] = productData["Name"].toString().split(' ');
    if(hasImage){
      productData["Thumbnail"] =files[0];
      productData["Image"] =files[1];
    }
    else{
      productData.remove("Thumbnail");
      productData.remove("Image");
    }
    try {
      var success = await FirebaseClass.createNewProduct(productData);
      productData["Image"] = InventoryImage(productId:  productData["ProductID"], imageType: "Images");
      productData["ProductID"] = await FirebaseClass.getNewProductID();

      nameController.text = "";
      modelController.text = "";
      categoryController.text = "";
      quantityController.text = "";
      commentController.text = "";
      imagePath = null;

      return success;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }

  }


}

