
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


import '../Classes/LogicClass.dart';
import '../Desktop/WidgetClass.dart';
import 'MainInterface.dart';



Size? screenSize;
String? method = "Cash";
String? reference;
String? bank = "Access 0061937122";
Map<String, dynamic> transactionData = {};
Map<String, dynamic> salesData = {};
class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final customerController = TextEditingController();
  final productController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final descController = TextEditingController();
  final amountController = TextEditingController();
  final bankController = TextEditingController();
  final accountController = TextEditingController();

  FocusNode customerNode = FocusNode();
  FocusNode productNode = FocusNode();

  Color labelColor =  WidgetClass.mainColor;
  List<bool> isSearching = [false,false,false];
  bool viewCustomers = false;
  bool viewProducts = false;
  bool collectPayment = false;
  bool createOrder = false;
  bool loadingOrder = true;
  bool processingOrder = false;
  int grandTotal = 0;
  // List<Widget> cancels = List.generate(2, (index) => Icon(Icons.cancel, color: Colors.red[400], size: 13,));

  File? imageFile;

  late  List<Map<String, dynamic>> items = [];
  late  Map<String, dynamic> customerData = {"Name":"", "Phone":"", "Address":""};
  late  List<Map<String, dynamic>> orderData = [];
  late List<dynamic> activeOrder = ["",false];
  late  Map<String, dynamic> productData = {"Name":"", "UnitPrice":0, "Quantity":0, "Total":0, "ProductID":"MK"};
  FocusNode  unitFocus = FocusNode();


  // imageFile.existsSync()

  @override
  void initState() {
    super.initState();
    checkOrderNo();
    pageLoading = false;
  }

  void checkOrderNo()async {
    activeOrder = await FirebaseClass.getOrderNo();
    if(activeOrder[1]){
      try {
        createOrder = true;
        var currentOrder= await updateCurrentOrder(false);
        customerData = currentOrder[0];
        currentOrder.removeAt(0);
        orderData = currentOrder;
      } catch (e) {
        createOrder = false;
        setState(() {});
      }
    }
    loadingOrder = false;
    setState(() {});

  }

  Future<List<Map<String, dynamic>>> updateCurrentOrder([bool remove = true]) async {
    var currentOrder = await FirebaseClass.getCurrentOrder();
    if(remove){
      currentOrder.removeAt(0);
    }

    orderData = currentOrder;
    grandTotal = 0;
    for(var totals in orderData.skip(!remove? 1:0)){
      grandTotal +=  totals["Total"]! as int;
    }
    return currentOrder;
  }



  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body:  Stack(
        children:[
           Positioned(
            top: 20,
            left: 15,
            child: Text("Customer Information", style: TextStyle(fontSize:  screenSize!.height * 0.016, fontWeight: FontWeight.bold, color: WidgetClass.mainColor),)),
          Positioned(
              top: 45,
              left: 15,
              child: SizedBox(width: screenSize!.width * 0.20 -50, child: TextField(
                // focusNode: customerNode,
                onSubmitted: (query) async{
                  viewCustomers = false;
                  viewProducts = false;
                  isSearching[0] = true;
                  setState(() { });
                  var result = await searchCustomer(query.toUpperCase());
                  result.isEmpty? items = [{"Name":"No Customer Found","CustomerID":"" }] : items = result;
                  items = result;
                  viewCustomers = true;
                  isSearching[0] = false;
                  setState(() {

                  });


                },

                style: const TextStyle(fontSize: 14),
                controller: customerController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    suffixIcon: isSearching[0]? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child: CircularProgressIndicator(strokeWidth: 2.0, color: mainColor, )),
                    ):
                    Container(transform:Matrix4.translationValues(10, 5, 0),
                        child:GestureDetector(
                            onTap: () async{
                              viewCustomers = false;
                              viewProducts = false;
                              isSearching[0] = true;
                              setState(() { });
                              var result = await searchCustomer(customerController.text.toUpperCase());
                              result.isEmpty? items = [{"Name":"No Customer Found","CustomerID":"" }] : items = result;
                              viewCustomers = true;
                              isSearching[0] = false;
                              setState(() {});},
                            child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Icon(Icons.search, color: mainColor,))
                        )),
                    label: const Text(
                      "Search Customer",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic),
                    ),labelStyle: TextStyle(fontSize: 12, color: labelColor)
                ),
              ))),
          Positioned(
              top: 90,
              left: 15,
              child: Visibility(
                visible: viewCustomers,
                child: SizedBox(
                  height: screenSize!.height * 0.24,
                  width: screenSize!.width * 0.20,
                  child: MouseRegion(
                    onExit: (event){
                      viewCustomers = false;
                      setState(() {

                      });

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right:50, top:5),
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) => InkWell(
                          hoverColor: mainColor.withOpacity(0.3),
                          splashColor: mainColor.withOpacity(0.8),
                          onTap: () async{
                            customerData = items.elementAt(index);
                            viewCustomers = false;
                            setState(() {});
                            await FirebaseClass.updateCurrentOrder(customerData);
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              color: mainColor.withAlpha(10),
                              border: Border.all(color:  mainColor.withOpacity(0.4), width: 1.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:10.0, top:3),
                                  child: Text(items.elementAt(index)["Name"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:10.0),
                                  child: Text("ID: ${items.elementAt(index)["CustomerID"]}",  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic,)),
                                ),
                              ],

                              // contentPadding: EdgeInsets.zero,

                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),
              ),
              ),
           Positioned(
              top: screenSize!.height * 0.4,
              left: 15,
              child:  Text("Product Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:  WidgetClass.mainColor),)),
          Positioned(
              top: screenSize!.height * 0.4 + 20,
              left: 15,
              child: SizedBox(width: screenSize!.width * 0.20 -50, child: TextField(
                // focusNode: productNode,
                onSubmitted: (query) async{
                  viewProducts = false;
                  viewCustomers = false;
                  isSearching[1] = true;
                  setState(() { });
                  var result = await searchProduct(query.toUpperCase());
                  result.isEmpty? items = [{"Name":"No Product Found","ProductID":"" }] : items = result;
                  items = result;
                  viewProducts = true;
                  isSearching[1] = false;
                  setState(() {

                  });

                },

                style: const TextStyle(fontSize: 14),
                controller: productController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    suffixIcon: isSearching[1]? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child: CircularProgressIndicator(strokeWidth: 2.0, color: mainColor, )),
                    ): Container(transform:Matrix4.translationValues(10, 5, 0),
                        child:GestureDetector(
                            onTap: () async{
                              viewProducts = false;
                              viewCustomers = false;
                              isSearching[1] = true;
                              setState(() { });
                              var result = await searchProduct(productController.text.toUpperCase());
                              result.isEmpty? items = [{"Name":"No Product Found","ProductID":"." }] : items = result;
                              viewProducts = true;
                              isSearching[1] = false;
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
              top: screenSize!.height * 0.4 + 80,
              left: 15,
              child: SizedBox(width: screenSize!.width * 0.20 -50, child: TextField(
                onSubmitted: (query){

                },
                style: const TextStyle(fontSize: 14),
                focusNode: unitFocus,
                controller: priceController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    label: const Text(
                      "Unit Price",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic),
                    ),labelStyle: TextStyle(fontSize: 12, color: labelColor)
                ),
              ))),
          Positioned(
              top: screenSize!.height * 0.4 + 140,
              left: 15,
              child: SizedBox(width: screenSize!.width * 0.20 -50, child: TextField(
                onSubmitted: (query) async {
                  for(var products in orderData){
                    if(products["ProductID"] == productData["ProductID"]){
                      SnackBar snackBar = SnackBar(backgroundColor: Colors.black87, content: Text("Duplicate Product Entered!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                  }
                  productData.putIfAbsent("UnitPrice", () => int.tryParse(priceController.text));
                  productData.putIfAbsent("Qty", () => int.tryParse(quantityController.text));
                  productData.putIfAbsent("Total", () => (int.tryParse(quantityController.text)! * int.tryParse(priceController.text)!) );
                  if(quantityController.text.isEmpty || priceController.text.isEmpty){
                    return;
                  }
                  orderData.add(productData);
                  grandTotal = 0;
                  for(var totals in orderData){
                    grandTotal +=  totals["Total"]! as int ;
                  }
                  await FirebaseClass.updateCurrentOrder(productData, true);
                  setState(() {});

                },

                style: const TextStyle(fontSize: 14),
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
            top: screenSize!.height * 0.4 + 200,
            left: 80,
            child: MyCustomButton(
              text: "Add Item",
              onPressed: () async {
                for(var products in orderData){
                  if(products["ProductID"] == productData["ProductID"]){
                    SnackBar snackBar = SnackBar(backgroundColor: Colors.black87, content: Text("Duplicate Product Entered!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                }
                productData.putIfAbsent("UnitPrice", () => int.tryParse(priceController.text));
                productData.putIfAbsent("Qty", () => int.tryParse(quantityController.text));
                productData.putIfAbsent("Total", () => (int.tryParse(quantityController.text)! * int.tryParse(priceController.text)!) );
                if(quantityController.text.isEmpty || priceController.text.isEmpty){
                  return;
                }
                orderData.add(productData);
                grandTotal = 0;
                for(var totals in orderData){
                  grandTotal +=  totals["Total"]! as int ;
                }
                await FirebaseClass.updateCurrentOrder(productData, true);
                setState(() {});
              },
              icon: Icons.add_box_rounded,
              size: const Size(130, 38)
            ),
          ),
          Positioned(
            top: screenSize!.height * 0.4 + 70,
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
              top:screenSize!.height * 0.6,
              right: screenSize!.width * 0.05,
              child:Visibility(
                visible:  createOrder,
                child: MyCustomButton(
                    text:  !createOrder? "Create Order" :"Cancel Order",
                    onPressed: () async {
                      createOrder = !createOrder;
                      if(!createOrder){
                        orderData = [];
                        customerData = {"Name":"", "Phone":"", "Address":""};
                      }
                      activeOrder = await FirebaseClass.getOrderNo(createOrder, true);
                      setState(() {

                      });
                    },
                    icon: !createOrder? FontAwesomeIcons.firstOrder : FontAwesomeIcons.ban,
                    size:  const Size(150,40)
                ),
              )
          ),
          Positioned(
              bottom:15,
              right: screenSize!.width * 0.05,
              child:MyCustomButton(
                  text: "Save and Print",
                  onPressed: () async{
                    if(!collectPayment){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(backgroundColor: Colors.black87, content: Text("Collect Payment First!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,));
                      return;

                    }
                    processingOrder = true;
                    setState((){});
                    processOrder([transactionData,salesData,customerData]);
                    await addPaymentDialog(context).then((value) => {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(backgroundColor: Colors.black87, content: Text("Order Processed Successfully!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,)
                    ),
                      checkOrderNo()

                    });
                    orderData = [];
                    grandTotal = 0;
                    customerData = {"Name":"", "Phone":"", "Address":""};
                    createOrder = false;
                    collectPayment = false;
                    setState(() {});

                  },
                  icon: FontAwesomeIcons.floppyDisk,
                  size:  const Size(150,40)
              )
          ),
          Positioned(
            // Order Page
            left:screenSize!.width * 0.21,
            child: Container(
              height: screenSize!.height * 0.92,
              width: screenSize!.width * 0.5,
              decoration: BoxDecoration(
                  // color: const Color(0xFFF8FFF8),
                  // border: Border.all(color:  WidgetClass.mainColor, width: 1.0),

                color: mainColor.withAlpha(10),
                border: Border.all(color:  mainColor.withOpacity(0.4), width: 1.0),
                ),
                child:createOrder ?
                Visibility(
                  visible: createOrder,
                  child: Stack(
                    children:  [
                      Positioned(
                        top:screenSize!.height * 0.016,
                        left: 20,
                        child: Text("MightyKens International Limited", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.02, fontWeight: FontWeight.bold),)
                      ),
                      Positioned(
                          top:screenSize!.height * 0.04,
                          left: 20,
                          child: Row(
                            children: [
                              Text("Order No:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016),),
                              Text(activeOrder[0].toString(), style: TextStyle(fontFamily: "Claredon", fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.016),),
                            ],
                          )
                      ),
                      Positioned(
                          top:screenSize!.height * 0.06,
                          left: 20,
                          child: Text(LogicClass.fullDate.format(DateTime.now()), style: TextStyle(fontFamily: "Claredon",fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.015),)
                      ),
                      Positioned(
                          top:screenSize!.height * 0.08,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("CUSTOMER:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016, fontWeight: FontWeight.bold),),
                              SizedBox(
                                  width: 250,
                                  child: Text(customerData["Name"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),)),
                              Text(customerData["Phone"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),),
                              SizedBox(
                                width: 250,
                                  child: Text(customerData["Address"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),))
                            ],
                          )
                      ),
                      Positioned(
                          top:screenSize!.height * 0.18,
                          left: screenSize!.width * 0.21,
                          child:  Text("Invoice", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.025, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),)
                      ),
                      Positioned(
                          top:screenSize!.height * 0.17,
                          left: 10,
                          child:   Container(height: 50,
                              width:  screenSize!.width * 0.49,
                              alignment: Alignment.bottomCenter,
                              child:   Divider( height: 10, color: mainColor.withOpacity(0.8), thickness: 2,)),
                      ),
                      Positioned(
                        top:screenSize!.height * 0.65,
                        left: 10,
                        child:   Container(height: 50,
                            width:  screenSize!.width * 0.49,
                            alignment: Alignment.bottomCenter,
                            child:   Divider( height: 10, color:  mainColor.withOpacity(0.8), thickness: 2,)),
                      ),
                      Positioned(
                          top:screenSize!.height * 0.235,
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
                          top:screenSize!.height * 0.265,
                          left: 20,
                          child: SizedBox(
                            height: screenSize!.height * 0.415,
                            width:  screenSize!.width * 0.485,
                            child: ListView.builder(
                              itemCount: orderData.length,
                              itemBuilder: (BuildContext context, int index) {
                                Widget image =  Image.asset(
                                  'assets/images/placeholder.jpg',
                                  fit:   BoxFit.cover,
                                );
                                if(orderData.isNotEmpty){
                                  final File imageFile = File('${Platform.environment['USERPROFILE']}\\AppData\\Local\\CachedImages\\Thumbnails\\${orderData.elementAt(index)["ProductID"]}.jpg');
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
                                          child: Text(orderData.elementAt(index)["Name"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),
                                      Text(orderData.elementAt(index)["UnitPrice"].toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                                      SizedBox(width: screenSize!.width * 0.01,),
                                      Text(orderData.elementAt(index)["Qty"].toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                                      SizedBox(width: screenSize!.width * 0.01,),
                                      SizedBox(
                                          width: screenSize!.width * 0.045,
                                          child: Text(LogicClass.returnCommaValue(orderData.elementAt(index)["Total"].toString()).replaceAll("N", ""), textAlign: TextAlign.right, style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w600),)),
                                      SizedBox(width: screenSize!.width * 0.01,
                                        child: GestureDetector(
                                            onTap: ()async{
                                              await FirebaseClass.deleteCurrentOrder(orderData.elementAt(index)["ProductID"].toString());
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
                          top:screenSize!.height * 0.72,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  width: screenSize!.width * 0.07,
                                  child: Text("Grand Total:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                              SizedBox(
                                  width: screenSize!.width * 0.06,
                                  child: Text(LogicClass.returnCommaValue(grandTotal.toString()), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                            ],
                          )
                      ),
                      Positioned(
                          top:screenSize!.height * 0.72,
                          left: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  width: screenSize!.width * 0.09,
                                  child: Text("No of Items:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                              SizedBox(
                                  width: screenSize!.width * 0.06,
                                  child: Text(orderData.length.toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                            ],
                          )
                      ),
                      Positioned(
                          top:screenSize!.height * 0.75,
                          left: 20,
                          child:!collectPayment ? MyCustomButton(
                            text: "Payment",
                            onPressed: ()async {
                              collectPayment = await addPaymentDialog(context) ?? false;
                              setState(() {});
                            },
                            icon: FontAwesomeIcons.moneyCheckDollar,
                            size:  Size(screenSize!.width * 0.08, screenSize!.height * 0.04)
                          ):  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: screenSize!.width * 0.09,
                                      child: Text("Payment Status:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                                  SizedBox(
                                      width: screenSize!.width * 0.2,
                                      child: Text("Paid ${amountController.text} with $method", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: screenSize!.width * 0.09,
                                      child: Text("Payment Ref:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                                  SizedBox(
                                      width: screenSize!.width * 0.09,
                                      child: Text(reference!, style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                                ],
                              )
                            ],
                          )
                      ),
                      Positioned(
                          top:screenSize!.height * 0.85,
                          left: screenSize!.width * 0.17,
                          child: Column(
                            children: [
                              SizedBox(
                                  child: Text("MightyKens International Limited:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.013, fontWeight: FontWeight.bold),)),
                              SizedBox(
                                  child: Text("08143255147", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.013, ),)),
                              SizedBox(
                                  child: Text("Cs 50 CorenerStone Plaza Ojo Lagos", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.013, ),)),
                              SizedBox(
                                  child: Text("Thanks for your Patronage...", style: TextStyle(fontFamily: "Claredon", fontStyle: FontStyle.italic , fontSize: screenSize!.height * 0.013, ),))
                            ],
                          )
                      ),
                    ],

            ),
                ) :
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(loadingOrder?"Loading Current Order... \n":" No Current Order \n ",  style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.03,  fontWeight: FontWeight.w400)),
                        Visibility(
                          visible: !loadingOrder,
                          child: MyCustomButton(
                              text:  !createOrder? "Create Order" :"Cancel Order",
                              onPressed: () async {
                                if(loadingOrder){
                                  return;
                                }
                                createOrder = !createOrder;
                                if(!createOrder){
                                  orderData = [];
                                }
                                activeOrder = await FirebaseClass.getOrderNo(createOrder, true);
                                setState(() {

                                });
                              },
                              icon: !createOrder? FontAwesomeIcons.firstOrder : FontAwesomeIcons.ban,
                              size:  const Size(150,40)
                          ),
                        )
                      ],
                    )
            )
          ),
        ],
      )
      ,
    );
  }

  Future<bool?> addPaymentDialog(BuildContext context) async {
    // Add this variable to track the editing state
    descController.text= "Complete Payment for Order ${activeOrder[0].toString()}";


    DateTime now = DateTime.now();
    String year = DateFormat('yy').format(now);
    String month = DateFormat('MM').format(now);
    String day = DateFormat('dd').format(now);
    String hour = DateFormat('HH').format(now);
    String minute = DateFormat('mm').format(now);
    String second = DateFormat('ss').format(now);
    reference ?? year + month + day + hour + minute + second;



    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: !processingOrder,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title:const Text('Collect Payment') ,
              content: SizedBox(
                width: screenSize!.width * 0.3,
                height: screenSize!.height * 0.75,
                child:processingOrder?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 100, height:100,child: CircularProgressIndicator(strokeWidth: 3.0, color: mainColor, )),
                    ),
                    Text("Processing Order...Please Wait!",  style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.03,  fontWeight: FontWeight.w400)),
                  ],
                ): Stack(children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Text(LogicClass.fullDate.format(DateTime.now()), style:  TextStyle(fontFamily: "claredon",fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.018,),),
                  ),
                  Positioned(
                    top: screenSize!.height * 0.03,
                    child:  Row(
                      children: [
                         Text("Reference: ", style: TextStyle(fontSize: screenSize!.height * 0.018),),
                        Text(reference!,
                            style:  TextStyle(fontWeight: FontWeight.bold, fontFamily: "claredon",fontSize: screenSize!.height * 0.018,)),
                      ],
                    ),
                  ),
                  Positioned(
                      top: screenSize!.height * 0.06,
                      child:  Row(
                        children: [
                           Text("Order: ", style: TextStyle(fontSize: screenSize!.height * 0.018,),),
                          Text(activeOrder[0].toString(),
                              style:  TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontFamily: "claredon", fontSize: screenSize!.height * 0.018,)),
                        ],
                      )),

                  Positioned(
                      top:  screenSize!.height * 0.09,
                      right: 20,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("Customer:", style: TextStyle(fontSize: screenSize!.height * 0.018,),),
                          Text(customerData["Name"],
                              style:  TextStyle(fontWeight: FontWeight.bold, fontFamily: "claredon", fontSize: screenSize!.height * 0.018,)),
                          Text("ID:${customerData["CustomerID"]}", style: TextStyle(fontSize: screenSize!.height * 0.016,),),
                        ],
                      )),

                  Positioned(
                      top: screenSize!.height * 0.17,
                      child:  Text(
                        "Description:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.018,),
                      )),
                  Positioned(
                      top: screenSize!.height * 0.2,
                      child: SizedBox(
                        width: screenSize!.width * 0.3,
                        child: TextField(
                          controller: descController,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: labelColor, width: 2.0),
                              ),
                            )),
                      )),
                  Positioned(
                      top:  screenSize!.height * 0.30,
                      child:  Text("Payment Method:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.018,))),
                  Positioned(
                    top: screenSize!.height * 0.33,
                    child: DropdownButton(
                        isExpanded: false,
                        value: method,
                        items: ["Cash", "Transfer", "Cheque", "Debit"]
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                            .toList(),
                        onChanged: (string) {
                          method = string;
                          setState(() {});
                        }),
                  ),
                  // Positioned(
                  //     top: screenSize!.height * 0.42,
                  //     child:  Text("Bank Details:",
                  //         style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.018,))),
                  //
                  Positioned(
                    top: screenSize!.height * 0.42,
                    child: Visibility(
                      visible: method == "Transfer" || method == "Cheque",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text("Bank Details:",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.018,)),
                          Row(
                            children: [
                              SizedBox(
                                  width:   screenSize!.width * 0.07,
                                  child: TextField(
                                      controller: bankController,
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: labelColor, width: 2.0),
                                          ),
                                          label:  Text("Bank Name", style: TextStyle(color: labelColor),)
                                      ))),
                              const SizedBox(width: 10),
                              SizedBox(
                                  width:   screenSize!.width * 0.1,
                                  child: TextField(
                                      controller: accountController,
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: labelColor, width: 2.0),
                                          ),
                                          label:  Text("Account Number", style: TextStyle(color: labelColor),)
                                      ))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: screenSize!.height * 0.53,
                      left: screenSize!.width * 0.1,
                      child: Column(
                        children: [
                          Text("Grand Total:",style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.025)),
                      Text(LogicClass.returnCommaValue(grandTotal.toString()), style: TextStyle(fontFamily: 'Majoris', fontSize: screenSize!.height * 0.03)),
                        ],
                      )),
                  Positioned(
                    top:  screenSize!.height * 0.61,
                    left: 20,
                      child: SizedBox(
                        width:   screenSize!.width * 0.15,
                          child: TextField(
                            onSubmitted: (string){
                              amountController.text = grandTotal.toString();

                              },
                              controller: amountController,
                              decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: labelColor, width: 2.0),
                            ),
                            label:  Text("Amount Paid", style: TextStyle(color: labelColor),)
                          ))),),
                  Positioned(
                      top:  screenSize!.height * 0.63,
                      left: screenSize!.width * 0.15 + 25,
                  child:MyCustomButton(
                      text: "Collect Payment",
                      onPressed: () async {
                        if(amountController.text.isEmpty){
                          return;
                        }
                        processingOrder = true;
                        updateCustomerData();
                        transactionData = createTransactionData();
                        salesData = createSalesData();
                        Navigator.of(context).pop(true);
                      },
                      icon: FontAwesomeIcons.handHoldingDollar,
                      size:  const Size(120,40)
                  )
              ),

                ]),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // User clicked on the Cancel button
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel'),
                ),

              ],
            );
          },
        );
      },
    );
  }

  void updateCustomerData(){
    print("Previous Customer Data $customerData \n");
    if(customerData["OrdersList"] == null){
      customerData["OrdersList"] = [activeOrder[0]];
    }else{
      List<dynamic> ordersList = customerData["OrdersList"].toList();
      ordersList.add(activeOrder[0]);
      customerData["OrdersList"] = ordersList;
    }
    if(customerData["TransactionList"] == null){
      customerData["TransactionList"] = [reference];
    }else{
      List<dynamic> transactions = customerData["TransactionList"].toList();
      transactions.add(reference);
      customerData["TransactionList"] = transactions;
    }
    //update balance
      String text = grandTotal > int.tryParse(amountController.text)!? "Partial":"Complete";
      int currentBal = customerData["Balance"];
      customerData["Balance"] = (grandTotal - int.tryParse(amountController.text)! + currentBal);
      descController.text= "$text Payment for Order ${activeOrder[0].toString()}";

    //update LastOrder
    customerData["LastOrder"] = DateTime.now();
    //update LastOrderNo
    customerData["LastOrderNo"] = activeOrder[0];
    //update OrdersAmount
    customerData["OrdersAmount"] = customerData["OrdersAmount"] + grandTotal;
    //TotalOrders
    customerData["TotalOrders"] =customerData["TotalOrders"] + 1;
    //TotalTransactions
    customerData["TotalTransactions"] = customerData["TotalTransactions"] + 1;
    //TransactionsAmount
    customerData["TransactionsAmount"] = customerData["TransactionsAmount"] + int.tryParse(amountController.text)!;

    print("Current Customer Data $customerData");

  }

  Map<String, dynamic> createTransactionData(){
    Map<String, dynamic> transactionData = {};
    //Date
    transactionData["Date"] = DateTime.now();
    //Reference
    transactionData["Reference"] = reference;
    //Description
    transactionData["Description"] = descController.text;
    //Amount
    transactionData["Amount"] = int.tryParse(amountController.text);
    //Method
    transactionData["Method"] = method;
    //Account
    transactionData["Account"] = "${bankController.text.toUpperCase().trim()} ${accountController.text}";
    //Status
    transactionData["Status"] = "Unconfirmed";
    //CustomerID
    transactionData["CustomerID"] = customerData["CustomerID"];
    //CustomerName
    transactionData["Name"] = customerData["Name"];
    //Order
    transactionData["Order"] = activeOrder[0];
    print("Previous transaction Data $transactionData \n");
    return transactionData;
  }
  Map<String, dynamic> createSalesData(){
    Map<String, dynamic> salesData = {};
    //Date
    salesData["Date"] = DateTime.now();
    //Order
    salesData["Order"] = activeOrder[0];
    //Amount
    salesData["Amount"] = grandTotal;
    //Paid
    salesData["Paid"] = int.tryParse(amountController.text);
    //Balance
    salesData["Balance"] = (grandTotal - int.tryParse(amountController.text)!);
    //Items
    salesData["Items"] = orderData.length.toString();
    //Product
    var itemsData = orderData;
    itemsData.map((map) {
      map.remove("index");
      map.remove("NameList");
      map.remove("Category");
      map.remove("Model");
      map.remove("Comment");
      return map;
    }).toList();
    salesData["Products"] = itemsData;
    //Reference
    salesData["Reference"] = reference;
    //Method
    salesData["Method"] = method;
    //Account
    salesData["Account"] = "${bankController.text.toUpperCase().trim()} ${accountController.text}";
    //Status
    salesData["Status"] = "Unconfirmed";
    //CustomerID
    salesData["CustomerID"] = customerData["CustomerID"];
    salesData["Name"] = customerData["Name"];
    print("Previous sales Data Data $salesData \n");

    return salesData;
  }

  Future<List<Map<String, dynamic>>> searchCustomer(String query) async{
    var result = await FirebaseClass.searchCustomers(query.trim());
    return result;
  }
  Future<List<Map<String, dynamic>>> searchProduct(String query) async{
    var result = await FirebaseClass.searchInventory(query.trim());
    return result;
  }
  Future<bool> processOrder(List<Map<String, dynamic>> data) async{
    var result = false;
    await FirebaseClass.processOrder(data).then((value) => {
    Navigator.of(context).pop(value),
    });

    return result;
  }
}
