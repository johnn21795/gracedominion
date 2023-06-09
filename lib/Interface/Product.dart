
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
Map<String, dynamic> selectedProductOrder = {};
String? productID;
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
  bool processingImage = false;
  bool isMoving = false;
  final nameController = TextEditingController();
  final modelController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final commentController = TextEditingController();
  final moveController = TextEditingController();
  final List<FocusNode> focusNode = List.generate(3, (index) => FocusNode());
  Map<String, dynamic> productData = {};
  String? selectedHistory = "All" ;
  String tableHistory = "ProductHistory";
  String? fromLocation;
  String? toLocation;
  String moveLocation= appName == "Warehouse" || appName == "Management"? "Showroom" : "Warehouse";

  int fromBal = 0;
  int toBal = 0;
  List<String> locations = ["All"];
  String? selectedLocation;

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

    }
  }



  @override
  void initState() {
    var x = MySavedPreferences.getPreference("WarehouseList");
    for(var y in x){
      locations.add(y.toString());
    }

    // pageLoading = false;
    if(widget.data["Name"] == "" && widget.data["Model"] == ""){
      isEditing = true;
      newProduct = true;
    }

    productData = widget.data;
    productID = productData["ProductID"];
    productData["Image"] = InventoryImage(productId:  productData["ProductID"], imageType: "Images");
    // WidgetsBinding.instance.addPostFrameCallback((_) { changeActivePage();});
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;
    return  Scaffold(
      floatingActionButton: MyFloatingActionButton(
        text: 'Move Product',
        onPressed: () async {
          await moveProductDialog(context).then((value) => {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: Colors.black87, content: Text("Product Moved Successfully!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,)
          ),
            isMoving = false,
            setState((){ }),});

        },
      ),
      body:  Stack(
        children: [
          Positioned(
            top: 30,
            right:15,

            child: SizedBox(
                width: screenSize!.width * 0.5,
                height: screenSize!.height * 0.87,
                child: TableClass(
                    tableColumns: {"No" :ColumnSize.S, "Date" :ColumnSize.S, "Customer":ColumnSize.M,"Previous":ColumnSize.S,selectedHistory == "All"? "Sold": "Supplied":ColumnSize.S,"Balance":ColumnSize.S},
                    tableName: "Product:$productID $tableHistory",
                    myFunction: (){
                      showOrderDialog(context, selectedProductOrder);
                    })
            ),
          ),
          Positioned(
              top:5,
              left: screenSize!.width * 0.43,
              child: SizedBox(
                  child: Text(selectedHistory == "All"? "Product History":"${LogicClass.returnTitleCase(selectedHistory!)}History"  , style: TextStyle(fontFamily: "Claredon", fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.022),))
          ),
          Positioned(
              top:0,
              right: screenSize!.width * 0.04,
              child:   SizedBox(
                height: 40,
                child:  DropdownButton(
                  alignment: AlignmentDirectional.bottomStart,
                    isExpanded: false,
                    dropdownColor: mainColor.withOpacity(0.9),
                    style: const TextStyle(color: Colors.white),
                    selectedItemBuilder: (BuildContext context) {
                      return locations.map((String value) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    underline: Container(
                      height: 1,
                      color: mainColor,
                    ),
                    value: selectedHistory,
                    items: locations
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ))
                        .toList(),
                    onChanged: (string) {
                      selectedHistory = string!;
                      string == "All"?
                      tableHistory = "ProductHistory":
                      tableHistory = "${LogicClass.returnTitleCase(selectedHistory!).trim()}History";
                      print(tableHistory);
                      setState(() {});
                    }),
              ),
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
                  isEditing && newProduct?  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          width:  screenSize!.width * 0.2,
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
                          )),
                      Column(
                        children: [
                          const Text("Location", style: TextStyle(fontSize: 11),),
                          Container(
                            transform:Matrix4.translationValues(0, 8, 0),
                            height: 30,
                            child: DropdownButton(
                              isExpanded: false,
                              value: fromLocation,
                              items:  locations.map( (item) => DropdownMenuItem< String>(
                                value: item,child: Text(item == "All" ? "": item,style: TextStyle(fontSize: screenSize!.height *0.017,  fontWeight: FontWeight.w400),),
                              ))
                                  .toList(),
                              onChanged: (string) async{
                                fromLocation = string;
                                setState(() {});
                              },
                              // onChanged: null,
                            ),
                          ),
                        ],
                      )
                    ],
                  ):
                  Text(
                    productData["Quantity"].toString(),
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
            Future.delayed(const Duration(milliseconds: 100), () async {
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
      if(fromLocation == null || fromLocation == "All" || fromLocation == ""){
          FocusScope.of(context).requestFocus(focusNode[2]);
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
                      await createNewProduct(files.isNotEmpty).then((value) =>
                      {
                      Navigator.of(context).pop(false),
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black87, content: Text(value? "Product Added Successfully!" : "Failed to Add Product", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,))
                      });

                    }else{
                      updateProduct(files.isNotEmpty && updateImage).then((value) =>
                      {
                        Navigator.of(context).pop(false),
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black87, content: Text(value? "Product Updated Successfully!" : "Failed to Update Product", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,))
                      });

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

  Future<bool?> moveProductDialog(BuildContext context) async {
    // Add this variable to track the editing state
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            List<String> from = [];
            for(var x in locations){
             if(x != "All"){
               from.add(x);
             }
            }
            return AlertDialog(
              title: const Text('Move Product'),
              content:  SizedBox(
                height: screenSize!.height * 0.43,
                child: Stack(
                  children: [
                    Positioned(top:0, left: 10, child: Row(
                      children: [
                        const Text("From: \t\t", style: TextStyle(fontFamily: "claredon", fontWeight: FontWeight.bold),),
                        DropdownButton(
                          isExpanded: false,
                          value: fromLocation,
                          items:  from.map( (item) => DropdownMenuItem< String>(
                                    value: item,child: Text(item,style: TextStyle(fontSize: screenSize!.height *0.017,  fontWeight: FontWeight.w400),),
                                  ))
                              .toList(),
                          onChanged: (string) async{
                            print(productData);
                            fromLocation = string;
                            setState(() {});
                          },
                          // onChanged: null,
                        )

                      ],
                    )),
                    Positioned(top:45, left: 10, child: Row(
                      children: [
                         Text("$fromLocation Stock: ", ),
                        Text(productData[fromLocation].toString(), style: const TextStyle(fontFamily: "claredon"),),
                        Text("\t\t\t $fromBal", style:  TextStyle(fontFamily: "claredon", color: Colors.red),),
                      ],
                    )),
                    Positioned(top:100, left: 10, child: Row(
                      children: [
                        const Text("To: \t\t", style: TextStyle(fontFamily: "claredon", fontWeight: FontWeight.bold),),
                        DropdownButton(
                          isExpanded: false,
                          value: toLocation,
                          items:  from.map( (item) => DropdownMenuItem< String>(
                            value: item,child: Text(item,style: TextStyle(fontSize: screenSize!.height *0.017,  fontWeight: FontWeight.w400),),
                          ))
                              .toList(),
                          onChanged: (string) async{
                            toLocation = string;
                            setState(() {});
                          },
                          // onChanged: null,
                        )

                      ],
                    )),
                    // const Positioned(top:25,left: 100, child: Text("To:")),
                    Positioned(top:150, left: 10, child: Row(
                      children: [
                        Text("$toLocation Stock: ", ),
                        Text(productData[toLocation].toString(), style: const TextStyle(fontFamily: "claredon"),),
                        Text("\t\t\t $toBal", style:  TextStyle(fontFamily: "claredon", color: Colors.green),),
                      ],
                    )),

                     Positioned(top:200,left: 10,
                        child: SizedBox(
                          width: screenSize!.width * 0.15,
                            child: TextField(
                              controller: moveController,
                              onChanged: (string){
                                try{
                                  // int? bal = int.tryParse(string);
                                  int x = int.tryParse(string)??0;
                                  if(x > productData[fromLocation]){
                                    moveController.text = "0";
                                    fromBal = 0;
                                    toBal = 0;
                                  }else{
                                    fromBal  = productData[fromLocation] - x as int;
                                    toBal  =x + productData[toLocation] as int;

                                    productData["Qty"] = x;
                                  }
                                  setState((){});

                                }catch(e){
                                  moveController.text = "0";
                                  fromBal = 0;
                                  toBal = 0;
                                  print(e);
                                }
                              },
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: labelColor, width: 2.0),
                                ),
                                suffixIcon: isMoving? Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                                  child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child:  CircularProgressIndicator(strokeWidth: 2.0, color: mainColor, )),
                                ): const SizedBox(),

                                label: const Text(
                                  "Quantity To Move",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic),
                                ),labelStyle: TextStyle(fontSize: 14, color: labelColor)
                                ,

                            )))),


                    Positioned(top:255,right: 10,
                        child: MyCustomButton(
                            text: "Move",
                            onPressed: () async {
                              isMoving = true;
                              setState((){ });
                              if(moveController.text != "0"){
                                await moveProduct().then((value) => {
                                  moveController.text = "",
                                  Navigator.of(context).pop(false),
                                });
                              }



                            },
                            icon: Icons.airport_shuttle,
                            size: const Size(100, 38)
                        ),
                            ),

                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // User clicked on the Cancel button
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close'),
                ),

              ],
            );
          },
        );
      },
    );
  }

  Future<bool> moveProduct() async {
    await FirebaseClass.moveProduct(productData,fromLocation!, toLocation!);
    return true;
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
    productData["Quantity"] = int.tryParse(quantityController.text);
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
    for(var loc in locations){
      productData[loc] = 0;
    }
    productData[fromLocation!] = int.tryParse(quantityController.text);
    try {
      var success = await FirebaseClass.createNewProduct(productData,fromLocation!);
      productData["Image"] = InventoryImage(productId:  productData["ProductID"], imageType: "Images");
      productID = productData["ProductID"];
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

  Future<bool?> showOrderDialog(BuildContext context, Map<String, dynamic> data) async {
    // Add this variable to track the editing state
    int noOfItems = 0;
    for(var element in data["Products"]){
      noOfItems +=  element["Qty"] as int;
    }
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title:  Text('Order ${data["Order"].toString()}'),
              content:  SizedBox(
                height: screenSize!.height ,
                width: screenSize!.width * 0.5,
                child: Stack(
                  children:  [
                    Positioned(
                        top:0,
                        left: 20,
                        child: Text("MightyKens International Limited", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.02, fontWeight: FontWeight.bold),)
                    ),
                    Positioned(
                        top:screenSize!.height * 0.025,
                        left: 20,
                        child: Row(
                          children: [
                            Text("Order No:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016),),
                            Text(data["Order"].toString(), style: TextStyle(fontFamily: "Claredon", fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.016),),
                          ],
                        )
                    ),
                    Positioned(
                        top:screenSize!.height * 0.04,
                        left: 20,
                        child: Text(LogicClass.fullDate.format(data["Date"]), style: TextStyle(fontFamily: "Claredon",fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.015),)
                    ),
                    Positioned(
                        top:screenSize!.height * 0.05,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("CUSTOMER:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016, fontWeight: FontWeight.bold),),
                            SizedBox(
                                width: 250,
                                child: Text(data["Name"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),)),
                            Text(data["Phone"].toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),),
                            SizedBox(
                                width: 250,
                                child: Text(data["Address"].toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),))
                          ],
                        )
                    ),
                    Positioned(
                        top:screenSize!.height * 0.13,
                        left: screenSize!.width * 0.22,
                        child:  Text("Invoice", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.025, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),)
                    ),
                    Positioned(
                      top:screenSize!.height * 0.13,
                      left: 10,
                      child:   Container(height: 50,
                          width:  screenSize!.width * 0.49,
                          alignment: Alignment.bottomCenter,
                          child:   Divider( height: 10, color: mainColor.withOpacity(0.8), thickness: 2,)),
                    ),
                    Positioned(
                      top:screenSize!.height * 0.60,
                      left: 10,
                      child:   Container(height: 50,
                          width:  screenSize!.width * 0.49,
                          alignment: Alignment.bottomCenter,
                          child:   Divider( height: 10, color:  mainColor.withOpacity(0.8), thickness: 2,)),
                    ),
                    Positioned(
                        top:screenSize!.height * 0.20,
                        left: 0,
                        child: Container(
                          width:  screenSize!.width * 0.49,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  width:  screenSize!.width * 0.32,
                                  child: Text(" \t\t\t Product Details", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),

                              SizedBox(
                                  width:  screenSize!.width * 0.06,
                                  child: Text("Unit Price", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),

                              SizedBox(
                                  width:  screenSize!.width * 0.04,
                                  child: Text("Qty", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),

                              SizedBox(
                                  width:  screenSize!.width * 0.045,
                                  child: Text("Total", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),
                              SizedBox(width: screenSize!.width * 0.005,),
                            ],
                          ),
                        )
                    ),
                    Positioned(
                        top:screenSize!.height * 0.24,
                        left: 20,
                        child: SizedBox(
                          height: screenSize!.height * 0.38,
                          width:  screenSize!.width * 0.485,
                          child: ListView.builder(
                            itemCount: data["Products"].length,
                            itemBuilder: (BuildContext context, int index) {
                              Widget image =  Image.asset(
                                'assets/images/placeholder.jpg',
                                fit:   BoxFit.cover,
                              );

                              if(data["Products"].isNotEmpty){

                                final File imageFile = File('${Platform.environment['USERPROFILE']}\\AppData\\Local\\CachedImages\\Thumbnails\\${data["Products"].elementAt(index)["ProductID"]}.jpg');
                                if(imageFile.existsSync()){
                                  image = Image.file(imageFile);
                                }
                              }


                              return Container(
                                width:  screenSize!.width * 0.49,
                                height: screenSize!.height * 0.06,
                                margin: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                                padding: EdgeInsets.zero,

                                decoration: BoxDecoration(
                                  color: mainColor.withAlpha(15),
                                  border: Border.all(color:  mainColor.withOpacity(0.6), width: 1.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: screenSize!.width * 0.04,
                                        child: image),
                                    SizedBox( width: screenSize!.width * 0.26,
                                        child: Text(data["Products"].elementAt(index)["Name"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),
                                    Text(data["Products"].elementAt(index)["UnitPrice"].toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                                    SizedBox(width: screenSize!.width * 0.01,),
                                    Text(data["Products"].elementAt(index)["Qty"].toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                                    SizedBox(width: screenSize!.width * 0.01,),
                                    SizedBox(
                                        width: screenSize!.width * 0.045,
                                        child: Text(LogicClass.returnCommaValue(data["Products"].elementAt(index)["Total"].toString()).replaceAll("N", ""), textAlign: TextAlign.right, style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w600),)),

                                  ],
                                ),
                              );
                            }
                            ,
                          ),
                        )
                    ),
                    Positioned(
                        top:screenSize!.height * 0.67,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: screenSize!.width * 0.07,
                                child: Text("Grand Total:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                            SizedBox(
                                width: screenSize!.width * 0.06,
                                child: Text(LogicClass.returnCommaValue(data["Amount"].toString()), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                          ],
                        )
                    ),
                    Positioned(
                        top:screenSize!.height * 0.67,
                        left: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: screenSize!.width * 0.09,
                                child: Text("No of Items:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                            SizedBox(
                                width: screenSize!.width * 0.06,
                                child: Text(noOfItems.toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                          ],
                        )
                    ),
                    Positioned(
                        top:screenSize!.height * 0.70,
                        left: 20,
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    width: screenSize!.width * 0.09,
                                    child: Text("Payment Status:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                                SizedBox(
                                    width: screenSize!.width * 0.2,
                                    child: Text("Paid ${data["Paid"]} with ${data["Method"]}", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width: screenSize!.width * 0.09,
                                    child: Text("Payment Ref:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                                SizedBox(
                                    width: screenSize!.width * 0.09,
                                    child: Text("${data["Reference"]}", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                              ],
                            )
                          ],
                        )
                    ),
                  ],

                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // User clicked on the Cancel button
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Print'),
                ),
                TextButton(
                  onPressed: () {
                    // User clicked on the Cancel button
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close'),
                ),


              ],
            );
          },
        );
      },
    );
  }


}

