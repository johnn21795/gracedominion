
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    MySavedPreferences.addPreference('scrollOffset', 0.0);
  }
  bool isEditing = false;
  final nameController = TextEditingController();
  final modelController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final commentController = TextEditingController();

  String cardLabel = "Search Payment";
  Color labelColor = WidgetClass.mainColor;
  bool isSearching = false;
  String? imagePath;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      String filePath = file.path!;
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
  Widget build(BuildContext context) {
    print(' name ${ widget.data}');

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
                    File(imagePath!),
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
                    "MK1001",
                    style: TextStyle(fontFamily: "Claredon",fontSize: screenSize!.height * 0.022,),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: screenSize!.height * 0.2,
              left: screenSize!.width * 0.15,
              child:MyCustomButton(
                  text: "Choose Image",
                  onPressed: pickFile,
                  icon: FontAwesomeIcons.fileImage,
                  size:  const Size(128,35)
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
                    widget.data.putIfAbsent("Name", () => ""),
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
                    "YEG-2-4DG",
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
                    "ELECTRIC GRIDDLE STANDING",
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
                    "500",
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
                    "Yellow Color",
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
                  onPressed: (){

                    if(!isEditing){
                      saveProductDialog(context);
                    }
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

  void saveProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Product'),
          content: const Text('Confirm Save Product'),
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
                Navigator.of(context).pop(true);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        // Action confirmed, perform the desired action here
        // ...
      } else {
        // Action canceled or dismissed
        // ...
      }
    });
  }
}
