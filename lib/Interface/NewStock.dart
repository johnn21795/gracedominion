
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


import '../Classes/LogicClass.dart';
import '../Desktop/WidgetClass.dart';
import 'MainInterface.dart';



Size? screenSize;
String? reference = "";
class NewStockPage extends StatefulWidget {
  const NewStockPage({Key? key}) : super(key: key);

  @override
  State<NewStockPage> createState() => _NewStockPageState();
}

class _NewStockPageState extends State<NewStockPage> {

  final productController = TextEditingController();
  final quantityController = TextEditingController();
  final shipRefController = TextEditingController();


  Color labelColor =  WidgetClass.mainColor;
  bool isSearching = false;
  bool viewProducts = false;
  bool loadingStock = true;
  bool processingStock = false;
  int grandTotal = 0;
  bool addStock = false;
  FocusNode  unitFocus = FocusNode();
  // List<Widget> cancels = List.generate(2, (index) => Icon(Icons.cancel, color: Colors.red[400], size: 13,));

  File? imageFile;

  late  List<Map<String, dynamic>> items = [];
  late  List<Map<String, dynamic>> stockData = [];
  late bool activeOrder = false;
  late  Map<String, dynamic> productData = {"Name":"", "UnitPrice":0, "Quantity":0, "Total":0, "ProductID":"MK"};



  // imageFile.existsSync()

  @override
  void initState() {
    super.initState();

    checkAddStock();
    pageLoading = false;
  }

  void checkAddStock()async {
    activeOrder = await FirebaseClass.checkAddStock();
    if(activeOrder){
      try {
        addStock = true;
        await updateCurrentOrder();
      } catch (e) {
        addStock = false;
        setState(() {});
      }
    }
    loadingStock = false;
    setState(() {});

  }

  Future<void> updateCurrentOrder() async {
    var currentOrder = await FirebaseClass.getAddStock();
    stockData = [];
    currentOrder.forEach((key, value) {
      // Perform operations with key and value
      print('Field: $key, Value: $value');
      stockData.add(value);
    });
    grandTotal = 0;
    for(var totals in stockData){
      grandTotal +=  totals["NewStock"]! as int;
    }
  }



  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body:  Stack(
        children:[
          Positioned(
              top: screenSize!.height * 0.02,
              left: 15,
              child:  Text("Product Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:  WidgetClass.mainColor),)),
          Positioned(
              top: screenSize!.height * 0.02 + 20,
              left: 15,
              child: SizedBox(width: screenSize!.width * 0.20 -50, child: TextField(
                // focusNode: productNode,
                onSubmitted: (query) async{
                  viewProducts = false;
                  isSearching = true;
                  setState(() { });
                  var result = await searchProduct(query.toUpperCase());
                  result.isEmpty? items = [{"Name":"No Product Found","ProductID":"" }] : items = result;
                  items = result;
                  viewProducts = true;
                  isSearching = false;
                  setState(() {});

                },

                style: const TextStyle(fontSize: 14),
                controller: productController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    suffixIcon: isSearching? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child: CircularProgressIndicator(strokeWidth: 2.0, color: mainColor, )),
                    ): Container(transform:Matrix4.translationValues(10, 5, 0),
                        child:GestureDetector(
                            onTap: () async{
                              viewProducts = false;
                              isSearching = true;
                              setState(() { });
                              var result = await searchProduct(productController.text.toUpperCase());
                              result.isEmpty? items = [{"Name":"No Product Found","ProductID":"." }] : items = result;
                              viewProducts = true;
                              isSearching= false;
                              setState(() {});},
                            child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Icon(Icons.search, color: mainColor,))
                        )),
                    label: const Text(
                      "Search Product",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic),
                    ),labelStyle: TextStyle(fontSize: 12, color: labelColor)
                ),
              ))),
          Positioned(
              top: screenSize!.height * 0.02 + 80,
              left: 15,
              child: SizedBox(width: screenSize!.width * 0.20 -50, child: TextField(
                onSubmitted: (query) async {
                  await addProduct();
                  setState(() {});
                },

                style: const TextStyle(fontSize: 14),
                focusNode: unitFocus,
                controller: quantityController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    label: const Text(
                      "Quantity",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic),
                    ),labelStyle: TextStyle(fontSize: 12, color: labelColor)
                ),
              ))),
          Positioned(
            top: screenSize!.height * 0.02 + 150,
            left: 80,
            child: MyCustomButton(
              text: "Add Item",
              onPressed: () async {
                await addProduct();
                setState(() {});
              },
              icon: Icons.add_box_rounded,
              size: const Size(130, 38)
            ),
          ),
          Positioned(
            bottom: screenSize!.height * 0.02,
            left: 30,
            child: MyCustomButton(
                text: "Clear All",
                onPressed: () async {
                  stockData = [];
                  addStock = false;
                  await FirebaseClass.updateAddStock(productData, true);
                  setState(() {});
                },
                icon: Icons.cancel_rounded,
                size: const Size(130, 38)
            ),
          ),
          Positioned(
            top: screenSize!.height * 0.02 + 70,
            left: 15,
            child: Visibility(
              visible: viewProducts,
              child: SizedBox(
                height: screenSize!.height * 0.24,
                width: screenSize!.width * 0.20,
                child: MouseRegion(
                  onExit: (event){
                    viewProducts = false;
                    setState(() {

                    });

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right:50, top:5),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final File imageFile = File('${Platform.environment['USERPROFILE']}\\AppData\\Local\\CachedImages\\Thumbnails\\${items.elementAt(index)["ProductID"]}.jpg');
                        Widget image =  Image.asset(
                          'assets/images/placeholder.jpg',
                          fit:   BoxFit.cover,
                        );
                        if(imageFile.existsSync()){
                          image = Image.file(imageFile);
                        }
                        return Container(
                          color: Colors.white.withOpacity(0.8),
                          child: InkWell(
                            hoverColor: mainColor.withOpacity(0.8),
                            splashColor: mainColor,
                            onTap: (){
                              viewProducts = false;
                              productController.text = items.elementAt(index)["Name"];
                              productData = items.elementAt(index);
                              print(productData);
                              unitFocus.requestFocus();
                              setState(() {});

                            },
                            child: Container(
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                // color: const Color(0xFFF8FFF8),
                                border: Border.all(color:  mainColor.withOpacity(0.4), width: 1.0),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: image,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:10.0, top:3),
                                          child: Text(items.elementAt(index)["Name"], style:  TextStyle(fontSize: screenSize!.height * 0.016, fontWeight: FontWeight.w500),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:10.0),
                                          child: Text("ID: ${items.elementAt(index)["ProductID"]}",  style:  TextStyle(fontSize:  screenSize!.height * 0.013, fontStyle: FontStyle.italic,)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                      }
                      ,
                    ),
                  ),
                ),
              ),
            ),
          ),


          Positioned(
              bottom:15,
              right: screenSize!.width * 0.05,
              child:Visibility(
                visible:  appName == "Management",
                child: MyCustomButton(
                    text: "Save to Stock",
                    onPressed: () async{
                      processingStock = true;
                      setState((){});
                      Map<String, dynamic> updateData = {};
                      for (var element in stockData) {
                        if(element["Location"] == null){
                          processingStock = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(backgroundColor: Colors.black87, content: Text("Select All Locations!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,));
                          return;
                        }
                        updateData[element["ProductID"]] = element;
                      }
                      processAddStock(updateData);
                      await savingStockDialog(context).then((value) => {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(backgroundColor: Colors.black87, content: Text("New Stock Added Successfully!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,)

                      ),
                      });
                      stockData = [];
                      grandTotal = 0;
                      addStock = false;
                      setState(() {});

                    },
                    icon: FontAwesomeIcons.floppyDisk,
                    size:  const Size(150,40)
                ),
              )
          ),
          Positioned(
            // Order Page
            left:screenSize!.width * 0.21,
            child: Container(
              height: screenSize!.height * 0.92,
              width: screenSize!.width * 0.5,
              decoration: BoxDecoration(
                color: mainColor.withAlpha(10),
                border: Border.all(color:  mainColor.withOpacity(0.4), width: 1.0),
                ),
                child:!addStock?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(loadingStock?"Checking for New Stock... \n":" No New Stock \n ",  style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.03,  fontWeight: FontWeight.w400)),
                    Visibility(
                      visible: !loadingStock,
                      child: MyCustomButton(
                          text:  "Add New Stock",
                          onPressed: () async {
                            addStock = true;
                            setState(() {

                            });
                          },
                          icon:Icons.add_chart,
                          size:  const Size(150,40)
                      ),
                    )
                  ],
                ):
                Stack(
                  children:  [
                    Positioned(
                      top:screenSize!.height * 0.016,
                      left: 20,
                      child: Text("MightyKens International Limited", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.02, fontWeight: FontWeight.bold),)
                    ),
                    Positioned(
                        top:45,
                        left: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 150, child: Text("Shipping Ref: ", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.018),)),
                            // Text(activeOrder[0].toString(), style: TextStyle(fontFamily: "Claredon", fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.016),),
                          ],
                        )
                    ),

                    Positioned(
                      top:30,
                      left: screenSize!.width * 0.085,
                      child: SizedBox(width: 150, height: 35, child:
                      TextField(
                        controller: shipRefController,
                        decoration:  InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: labelColor, width: 2.0),
                          ),
                        ),
                        style: TextStyle(fontSize: screenSize!.height * 0.018), cursorHeight: screenSize!.height * 0.018, cursorColor: labelColor, textAlignVertical: TextAlignVertical.top, textAlign: TextAlign.start,)
                      ),
                    ),
                    Positioned(
                        top:screenSize!.height * 0.04,
                        right: 20,
                        child: Text(LogicClass.fullDate.format(DateTime.now()), style: TextStyle(fontFamily: "Claredon",fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.015),)
                    ),

                    Positioned(
                        top:screenSize!.height * 0.12,
                        left: screenSize!.width * 0.21,
                        child:  Text("NEW STOCK", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.025, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),)
                    ),
                    Positioned(
                        top:screenSize!.height * 0.10 +5 ,
                        left: 10,
                        child:   Container(height: 50,
                            width:  screenSize!.width * 0.49,
                            alignment: Alignment.bottomCenter,
                            child:   Divider( height: 10, color: mainColor.withOpacity(0.8), thickness: 2,)),
                    ),
                    Positioned(
                      top:screenSize!.height * 0.77,
                      left: 10,
                      child:   Container(height: 50,
                          width:  screenSize!.width * 0.49,
                          alignment: Alignment.bottomCenter,
                          child:   Divider( height: 10, color:  mainColor.withOpacity(0.8), thickness: 2,)),
                    ),
                    Positioned(
                        top:screenSize!.height * 0.175,
                        left: 0,
                        child: Container(
                          width:  screenSize!.width * 0.49,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  width:  screenSize!.width * 0.32,
                                  child: Text("\t\t\t\tProduct \n\t\t\t\tDetails", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),

                              SizedBox(
                                  width:  screenSize!.width * 0.06,
                                  child: Text("Previous Balance", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),

                              SizedBox(
                                  width:  screenSize!.width * 0.04,
                                  child: Text("New Stock", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),

                              SizedBox(
                                  width:  screenSize!.width * 0.045,
                                  child: Text("Current Balance", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),
                              SizedBox(width: screenSize!.width * 0.005,),
                            ],
                          ),
                        )
                    ),
                    Positioned(
                        top:screenSize!.height * 0.265,
                        left: 20,
                        child: SizedBox(
                          height: screenSize!.height * 0.55,
                          width:  screenSize!.width * 0.485,
                          child: ListView.builder(
                            itemCount: stockData.length,
                            itemBuilder: (BuildContext context, int index) {
                              Widget image =  Image.asset(
                                'assets/images/placeholder.jpg',
                                fit:   BoxFit.cover,
                              );
                              if(stockData.isNotEmpty){
                                final File imageFile = File('${Platform.environment['USERPROFILE']}\\AppData\\Local\\CachedImages\\Thumbnails\\${stockData.elementAt(index)["ProductID"]}.jpg');
                                if(imageFile.existsSync()){
                                  image = Image.file(imageFile);
                                }
                              }

                              return Container(
                                width:  screenSize!.width * 0.49,
                                height: screenSize!.height * 0.1,
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
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(stockData.elementAt(index)["Name"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),),
                                            Container(
                                              transform: Matrix4.translationValues(0, -10, 0),
                                              height: 38,
                                              child: Row(
                                                children: [
                                                  Text("Location:\t\t ", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015, ),),
                                                  DropdownButton(
                                                    isExpanded: false,
                                                    value: stockData.elementAt(index)["Location"],
                                                    items:  locations.map( (item) => DropdownMenuItem< String>(
                                                      value: item,child: Text(item,style: TextStyle(fontSize: screenSize!.height *0.017,  fontWeight: FontWeight.w400),),
                                                    ))
                                                        .toList(),
                                                    onChanged: (string) async{
                                                      stockData.elementAt(index)["Location"] = string;
                                                      FirebaseClass.updateAddStock({ stockData.elementAt(index)["ProductID"]:stockData.elementAt(index)});
                                                      // FirebaseClass.updateDynamic("Other", "AddStock", {"${stockData.elementAt(index)["ProductID"]}.Location": string});
                                                      setState(() {});
                                                    },
                                                    // onChanged: null,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    Text(stockData.elementAt(index)["Quantity"].toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                                    SizedBox(width: screenSize!.width * 0.01,),
                                    Text(stockData.elementAt(index)["NewStock"].toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                                    SizedBox(width: screenSize!.width * 0.01,),
                                    SizedBox(
                                        width: screenSize!.width * 0.045,
                                        child: Text(stockData.elementAt(index)["Current"].toString(), textAlign: TextAlign.right, style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w600),)),
                                    SizedBox(width: screenSize!.width * 0.01,
                                      child: GestureDetector(
                                          onTap: ()async{
                                            print("Previous StockData $stockData  \n \n");
                                            String productID = stockData.elementAt(index)["ProductID"];
                                            Map<String, dynamic> updateData = {};
                                            for (var element in stockData) {
                                              if(element["ProductID"] != productID){
                                                updateData[element["ProductID"]] = element;
                                              }
                                            }
                                            print("Current StockData $updateData");
                                            await FirebaseClass.updateProductStock(updateData);
                                            await updateCurrentOrder();
                                            setState(() {});

                                          },
                                          child: Icon(Icons.cancel, color: Colors.red[400], size: 13,)

                                          ),),
                                  ],
                                ),
                              );
                            }
                            ,
                          ),
                        )
                    ),
                    Positioned(
                        top:screenSize!.height * 0.85,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: screenSize!.width * 0.07,
                                child: Text("Total Goods:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                            SizedBox(
                                width: screenSize!.width * 0.06,
                                child: Text(grandTotal.toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                          ],
                        )
                    ),
                    Positioned(
                        top:screenSize!.height * 0.85,
                        left: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: screenSize!.width * 0.09,
                                child: Text("No of Items:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                            SizedBox(
                                width: screenSize!.width * 0.06,
                                child: Text(stockData.length.toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                          ],
                        )
                    ),


                  ],

            )

            )
          ),
        ],
      )
      ,
    );
  }

  Future<bool?> savingStockDialog(BuildContext context) async {
    // Add this variable to track the editing state

    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: !processingStock,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title:const Text('Add Stock') ,
              content: SizedBox(
                width: screenSize!.width * 0.3,
                height: screenSize!.height * 0.75,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 100, height:100,child: CircularProgressIndicator(strokeWidth: 3.0, color: mainColor, )),
                    ),
                    Text("Adding New Stock...Please Wait!",  style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.03,  fontWeight: FontWeight.w400)),
                  ],
                )
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> searchCustomer(String query) async{
    var result = await FirebaseClass.searchCustomers(query.trim());
    return result;
  }
  Future<List<Map<String, dynamic>>> searchProduct(String query) async{
    var result = await FirebaseClass.searchInventory(query.trim());
    return result;
  }
  Future<bool> processAddStock(Map<String, dynamic> data) async{
    var result = false;
    await FirebaseClass.addNewStock(data, shipRefController.text.isEmpty? "": shipRefController.text).then((value) => {
    Navigator.of(context).pop(value),
    });

    return result;
  }

  Future<void> addProduct() async{
    for(var products in stockData){
      if(products["ProductID"] == productData["ProductID"]){
        SnackBar snackBar = SnackBar(backgroundColor: Colors.black87, content: Text("Duplicate Product Entered!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    }
    if(quantityController.text.isEmpty){
      return;
    }
    productData.putIfAbsent("NewStock", () => int.tryParse(quantityController.text));
    productData.putIfAbsent("Current", () => int.tryParse(quantityController.text)! + int.parse(productData["Quantity"].toString()));
    stockData.add(productData);
    grandTotal = 0;
    for(var totals in stockData){
      grandTotal +=  totals["NewStock"]! as int ;
    }
    await FirebaseClass.updateAddStock({productData["ProductID"]:productData});
  }
}
