
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
  final nameController = TextEditingController();
  final modelController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final commentController = TextEditingController();


  Color labelColor = WidgetClass.mainColor;
  String? imagePath;
  late List<File?> files;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      String filePath = file.path!;
      files = await CalculateClass().selectImage(filePath);
      // Use the selected file path for further processing
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
    if(widget.data["Name"] == "" && widget.data["Model"] == ""){
      isEditing = true;
      newProduct = true;
    }
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
                child: TableClass(tableColumns: {"No" :ColumnSize.S, "Dates" :ColumnSize.S, "Customer":ColumnSize.M,"Previous":ColumnSize.S,"Sold":ColumnSize.S,"Balance":ColumnSize.S}, tableName: "Sales", myFunction: (){})
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
                  child:  imagePath != null
                      ? Image.file(
                    files[1]!,
                    fit: BoxFit.cover,
                  )
                      : const Image(
                    image: AssetImage('assets/images/placeholder.jpg'),
                    fit: BoxFit.cover,
                  ))
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
                    widget.data["ProductID"],
                    style: TextStyle(fontFamily: "Claredon",fontSize: screenSize!.height * 0.022,),
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
                        const Text('Update Image', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
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
                        onSubmitted: (query){},
                        style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                        controller: nameController,
                        decoration:  InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: labelColor, width: 2.0),
                          ),
                          suffixIcon: Icon(Icons.edit, color: mainColor,)),
                      )):
                  Text(
                    widget.data["Name"],
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
                    onSubmitted: (query){},
                style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                controller: modelController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    suffixIcon:  Icon(Icons.edit, color: mainColor,)),
              )):
                  Text(
                    widget.data["Model"],
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
                        onSubmitted: (query){},
                        style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                        controller: categoryController,
                        decoration:  InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: labelColor, width: 2.0),
                          ),
                          suffixIcon:  Icon(Icons.edit, color: WidgetClass.mainColor,)),
                      )):Text(
                    widget.data["Category"],
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
                  isEditing? SizedBox(
                      width:  screenSize!.width * 0.32,
                      child: TextField(
                        onSubmitted: (query){},
                        style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                        controller: quantityController,
                        decoration:  InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: labelColor, width: 2.0),
                            ),
                            suffixIcon:  Icon(Icons.edit, color: WidgetClass.mainColor,)),
                      )):
                  Text(
                    widget.data["Quantity"],
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
                    widget.data["Comment"],
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
                  text:isEditing? "Save Product" : "Edit Product",
                  onPressed: () async{
                    isEditing ? await saveProductDialog(context) : isEditing = true;
                    setState(() {

                    });
                  },
                  icon:isEditing? FontAwesomeIcons.floppyDisk : FontAwesomeIcons.penToSquare,
                  size:  const Size(170,40)
              )
          ),





        ]
        ,
      )
      ,
    );
  }

  Future<bool?> saveProductDialog(BuildContext context) async {
   // Add this variable to track the editing state

    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black,
      barrierDismissible: isEditing,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(

              title: const Text('Save Product'),
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
                  : const Text('Confirm Save Product'),
              actions: [
                TextButton(
                  onPressed: () {
                    // User clicked on the Cancel button
                    isEditing = true;
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // User clicked on the Confirm button
                    isEditing = false;
                    setState((){});
                    // Navigator.of(context).pop(true);
                  },
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }


}
