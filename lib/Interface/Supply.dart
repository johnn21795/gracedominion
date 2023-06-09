import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Classes/LogicClass.dart';
import '../Desktop/WidgetClass.dart';
import 'MainInterface.dart';

Size? screenSize;

class SupplyPage extends StatefulWidget {
  const SupplyPage({Key? key}) : super(key: key);

  @override
  State<SupplyPage> createState() => _SupplyPageState();
}

class _SupplyPageState extends State<SupplyPage> {
  final customerController = TextEditingController();
  final productController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  FocusNode customerNode = FocusNode();
  FocusNode productNode = FocusNode();

  Color labelColor = mainColor;
  bool isSearching = false;
  bool viewCustomers = false;
  bool viewProducts = false;
  bool collectPayment = false;
  bool createOrder = false;
  bool processingOrder = false;

  Map<String, dynamic> orderData = {"Products":[]};
  late List<String?> selectedValues;
  int noOfItems = 0;

  @override
  void initState() {
    super.initState();
    customerNode.addListener(_onFocusChange);
    productNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (customerNode.hasFocus) {
      viewCustomers = true;
    } else {
      viewCustomers = false;
      setState(() {});
    }

    if (productNode.hasFocus) {
      viewProducts = true;
    } else {
      viewProducts = false;
      print("Product lost focus");
      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 10,
            top: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  height: 100,
                  width: screenSize!.width * 0.1,
                  child: TextField(
                    onSubmitted: (query) async {
                      isSearching = true;
                      setState(() {});
                      var result = await loadOrder(
                          customerController.text.toUpperCase());
                      if (result.isEmpty) {
                        orderData.clear();
                        createOrder = false;
                      }else{
                        var len = result["Products"] as List;
                        selectedValues = List.generate(len.length, (_) => null);
                        noOfItems = 0;
                        for (var element in result["Products"]) {
                          noOfItems += element["Qty"] as int;
                        }
                        orderData = result;
                        createOrder = true;
                      }
                      isSearching = false;
                      setState(() {});
                    },
                    style: const TextStyle(fontSize: 14),
                    controller: customerController,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: labelColor, width: 2.0),
                        ),
                        suffixIcon: isSearching
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10.0,bottom: 10.0,right: 18.0,left: 1.0),
                                child: Container(
                                    transform:Matrix4.translationValues(10, 5, 0),
                                    width: 10,
                                    height: 10,
                                    child:  CircularProgressIndicator( color: mainColor,
                                        strokeWidth: 2.0)),
                              )
                            : const SizedBox(),
                        label: const Text(
                          "Order No",
                          textAlign: TextAlign.right,
                          style:
                              TextStyle(textBaseline: TextBaseline.alphabetic),
                        ),
                        labelStyle: TextStyle(fontSize: 12, color: labelColor)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: MyCustomButton(
                      text: "Load",
                      onPressed: () async {
                        isSearching = true;
                        setState(() {});
                        var result = await loadOrder(
                            customerController.text.toUpperCase());
                        if (result.isEmpty) {
                            orderData.clear();
                            createOrder = false;
                        }else{
                          var len = result["Products"] as List;
                          selectedValues = List.generate(len.length, (_) => null);
                          noOfItems = 0;
                          for (var element in result["Products"]) {
                            noOfItems += element["Qty"] as int;
                          }
                          orderData = result;
                          createOrder = true;
                        }
                        isSearching = false;
                        setState(() {});
                      },
                      icon: Icons.label,
                      size: const Size(100, 35)),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 15,
              right: screenSize!.width * 0.05,
              child: MyCustomButton(
                  text: "Save and Supply",
                  onPressed: () async{
                    if(orderData["Status"] != "Confirmed"){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(backgroundColor: Colors.black87, content: Text("Order has not been Confirmed!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,));
                      return;
                    }
                    for(var x in selectedValues){
                      if(x == null){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black87, content: Text("Location not Selected!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,));
                        return;
                      }
                    }
                    await showConfirmDialog(context);
                    setState(() { });

                  },
                  icon: FontAwesomeIcons.floppyDisk,
                  size: const Size(150, 38))),
          Positioned(
              left: screenSize!.width * 0.21,
              child: Container(
                height: screenSize!.height * 0.92,
                width: screenSize!.width * 0.5,
                decoration: BoxDecoration(
                  color: mainColor.withAlpha(7),
                  border:
                      Border.all(color: mainColor.withOpacity(0.4), width: 1.0),
                ),
                child: createOrder? Stack(
                        children: [
                          Positioned(
                              top: screenSize!.height * 0.016,
                              left: 20,
                              child: Text(
                                "MightyKens International Limited",
                                style: TextStyle(
                                    fontFamily: "Claredon",
                                    fontSize: screenSize!.height * 0.02,
                                    fontWeight: FontWeight.bold),
                              )),
                          Positioned(
                              top: screenSize!.height * 0.04,
                              left: 20,
                              child: Row(
                                children: [
                                  Text(
                                    "Order No: ",
                                    style: TextStyle(
                                        fontFamily: "Claredon",
                                        fontSize: screenSize!.height * 0.016),
                                  ),
                                  Text(
                                    orderData["Order"].toString(),
                                    style: TextStyle(
                                        fontFamily: "Claredon",
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenSize!.height * 0.016),
                                  ),
                                ],
                              )),
                          Positioned(
                              top: screenSize!.height * 0.06,
                              left: 20,
                              child: Text(
                                LogicClass.fullDate.format(
                                    orderData["Date"] ?? DateTime.now()),
                                style: TextStyle(
                                    fontFamily: "Claredon",
                                    fontSize: screenSize!.height * 0.015),
                              )),
                          Positioned(
                              top: screenSize!.height * 0.08,
                              right: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "CUSTOMER:\t\t\t\t",
                                        style: TextStyle(
                                            fontFamily: "Claredon",
                                            fontSize:
                                                screenSize!.height * 0.016,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        orderData["CustomerID"].toString(),
                                        style: TextStyle(
                                            fontFamily: "Claredon",
                                            fontSize:
                                                screenSize!.height * 0.014),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      width: 250,
                                      child: Text(
                                        orderData["Name"].toString(),
                                        style: TextStyle(
                                            fontFamily: "Claredon",
                                            fontSize:
                                                screenSize!.height * 0.015),
                                      )),
                                  Text(
                                    orderData["Phone"].toString(),
                                    style: TextStyle(
                                        fontFamily: "Claredon",
                                        fontSize: screenSize!.height * 0.015),
                                  ),
                                  SizedBox(
                                      width: 250,
                                      child: Text(
                                        orderData["Address"].toString(),
                                        style: TextStyle(
                                            fontFamily: "Claredon",
                                            fontSize:
                                                screenSize!.height * 0.015),
                                      ))
                                ],
                              )),
                          Positioned(
                              top: screenSize!.height * 0.18,
                              left: screenSize!.width * 0.22,
                              child: Text(
                                "Invoice",
                                style: TextStyle(
                                    fontFamily: "Claredon",
                                    fontSize: screenSize!.height * 0.025,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              )),
                          Positioned(
                            top: screenSize!.height * 0.17,
                            left: 10,
                            child: Container(
                                height: 50,
                                width: screenSize!.width * 0.49,
                                alignment: Alignment.bottomCenter,
                                child: Divider(
                                  height: 10,
                                  color: mainColor.withOpacity(0.8),
                                  thickness: 2,
                                )),
                          ),
                          Positioned(
                            top: screenSize!.height * 0.65,
                            left: 10,
                            child: Container(
                                height: 50,
                                width: screenSize!.width * 0.49,
                                alignment: Alignment.bottomCenter,
                                child: Divider(
                                  height: 10,
                                  color: mainColor.withOpacity(0.8),
                                  thickness: 2,
                                )),
                          ),
                          Positioned(
                              top: screenSize!.height * 0.235,
                              left: 0,
                              child: Container(
                                width: screenSize!.width * 0.49,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: screenSize!.width * 0.35,
                                        child: Text(
                                          " \t\t\t Product Details",
                                          style: TextStyle(
                                              fontFamily: "Claredon",
                                              fontSize:
                                                  screenSize!.height * 0.017,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                        width: screenSize!.width * 0.04,
                                        child: Text(
                                          "Qty",
                                          style: TextStyle(
                                              fontFamily: "Claredon",
                                              fontSize:
                                                  screenSize!.height * 0.017,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      width: screenSize!.width * 0.001,
                                    ),
                                    SizedBox(
                                        width: screenSize!.width * 0.07,
                                        child: Text(
                                          "Supply From",
                                          style: TextStyle(
                                              fontFamily: "Claredon",
                                              fontSize:
                                                  screenSize!.height * 0.017,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              )),
                          Positioned(
                              top: screenSize!.height * 0.265,
                              left: 20,
                              child: SizedBox(
                                height: screenSize!.height * 0.415,
                                width: screenSize!.width * 0.485,
                                child: ListView.builder(
                                    itemCount: orderData["Products"] == null ? 0 :  orderData["Products"].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Widget image = Image.asset(
                                        'assets/images/placeholder.jpg',
                                        fit: BoxFit.cover,
                                      );

                                      if (orderData["Products"].isNotEmpty) {
                                        final File imageFile = File(
                                            '${Platform.environment['USERPROFILE']}\\AppData\\Local\\CachedImages\\Thumbnails\\${orderData["Products"].elementAt(index)["ProductID"]}.jpg');
                                        if (imageFile.existsSync()) {
                                          image = Image.file(imageFile);
                                        }
                                      }

                                      return Container(
                                        width: screenSize!.width * 0.49,
                                        height: screenSize!.height * 0.06,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 3, 0, 5),
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          color: mainColor.withAlpha(15),
                                          border: Border.all(
                                              color: mainColor.withOpacity(0.6),
                                              width: 1.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                                width: screenSize!.width * 0.04,
                                                child: image),
                                            SizedBox(
                                                width: screenSize!.width * 0.27,
                                                child: Text(
                                                  orderData["Products"]
                                                      .elementAt(index)["Name"],
                                                  style: TextStyle(
                                                      fontFamily: "Claredon",
                                                      fontSize:
                                                          screenSize!.height *
                                                              0.017,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),

                                            // SizedBox(width: screenSize!.width * 0.01,),
                                            Text(
                                              orderData["Products"]
                                                  .elementAt(index)["Qty"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: "Claredon",
                                                  fontSize: screenSize!.height *
                                                      0.017,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              width: screenSize!.width * 0.01,
                                            ),
                                            Center(
                                              child:
                                              orderData["Supplied"].toString() != "Supplied"?
                                              DropdownButton(
                                                isExpanded: false,
                                                value: selectedValues[index],
                                                items:
                                                  locations.map(
                                                        (item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        screenSize!.height *
                                                                            0.017,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ))
                                                    .toList(),
                                                onChanged: (string) async{
                                                  print(string);
                                                  orderData["Products"].elementAt(index)["Location"] = string;
                                                 await getDynamic("Product", orderData["Products"].elementAt(index)["ProductID"], string!).then((value) =>
                                                  {
                                                 print(" value $value"),
                                                    print("Products value ${orderData["Products"].elementAt(index)["Qty"]}"),
                                                    if(value == null || orderData["Products"].elementAt(index)["Qty"]  > value ){
                                                     ScaffoldMessenger.of(context).showSnackBar(
                                                     SnackBar(backgroundColor: Colors.black87, content: Text("Not Enough Stock in $string!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,)),
                                                      selectedValues[index] = null
                                                    }else{
                                                     selectedValues[index] = string
                                                    }
                                                  });

                                                  setState(() {});
                                                },
                                                // onChanged: null,
                                              ):
                                              Text(orderData["Products"].elementAt(index)["Location"].toString())
                                              ,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              )),
                          Positioned(
                              top: screenSize!.height * 0.72,
                              left: 20,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      width: screenSize!.width * 0.09,
                                      child: Text(
                                        "No of Items:",
                                        style: TextStyle(
                                            fontFamily: "Claredon",
                                            fontSize:
                                                screenSize!.height * 0.017,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  SizedBox(
                                      width: screenSize!.width * 0.06,
                                      child: Text(
                                        noOfItems.toString(),
                                        style: TextStyle(
                                            fontFamily: "Claredon",
                                            fontSize:
                                                screenSize!.height * 0.017,
                                            fontWeight: FontWeight.bold),
                                      ))
                                ],
                              )),
                          Positioned(
                              top: screenSize!.height * 0.75,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: screenSize!.width * 0.09,
                                          child: Text(
                                            "Order Status:",
                                            style: TextStyle(
                                                fontFamily: "Claredon",
                                                fontSize:
                                                    screenSize!.height * 0.017,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      SizedBox(
                                          width: screenSize!.width * 0.2,
                                          child: Text(
                                            orderData["Status"] ?? "",
                                            style: TextStyle(
                                                fontFamily: "Claredon",
                                                color: orderData["Status"] == "Confirmed"? Colors.green : Colors.red,
                                                fontSize:
                                                    screenSize!.height * 0.017,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: screenSize!.width * 0.09,
                                          child: Text(
                                            "Payment Ref:",
                                            style: TextStyle(
                                                fontFamily: "Claredon",
                                                fontSize:
                                                    screenSize!.height * 0.017,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      SizedBox(
                                          width: screenSize!.width * 0.09,
                                          child: Text(
                                            orderData["Reference"].toString(),
                                            style: TextStyle(
                                                fontFamily: "Claredon",
                                                fontSize:
                                                    screenSize!.height * 0.017,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  )
                                ],
                              )),
                          Positioned(
                              top: screenSize!.height * 0.72,
                              right: 20,child: Text(orderData["Supplied"].toString() != "Supplied"? "Not Supplied" : "Supplied", style:
                          TextStyle(fontSize:screenSize!.height * 0.017, color: orderData["Supplied"].toString() != "Supplied"? Colors.red: Colors.green, fontWeight: FontWeight.bold ),))

                        ],
                      )
                    :  Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            orderData.isEmpty?  Icons.disabled_by_default_sharp:  Icons.search_rounded,
                            size: screenSize!.width * 0.05,
                            color: mainColor,
                          ),
                          Text(
                            orderData.isEmpty? "Order Not Found": "Search Order",
                            style:
                                TextStyle(fontSize: screenSize!.width * 0.015),
                          ),
                        ],
                      )),
              )),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> loadOrder(String query) async {
    var result = await FirebaseClass.loadOrder(query.trim());
    return result;
  }
  Future<bool> processSupply() async {

    var result = await FirebaseClass.processSupply(orderData["Products"], orderData["Order"].toString(), orderData["Name"].toString(),orderData["CustomerID"].toString());
    return result;
  }
  Future<dynamic> getDynamic(String collection, String product, String field) async {
    var result = await FirebaseClass.getDynamic(collection, product, field);
    return result;
  }

  Future<bool?> showConfirmDialog(BuildContext context) async {
    // Add this variable to track the editing state
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: !processingOrder,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Confirm Goods Supply'),
              content:  SizedBox(
                height: screenSize!.height * 0.15,
                child:processingOrder?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: screenSize!.height * 0.06, height:screenSize!.height * 0.06,child: CircularProgressIndicator(strokeWidth: 3.0, color: mainColor, )),
                    ),
                    Text("Processing Order...Please Wait!",  style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.03,  fontWeight: FontWeight.w400)),
                  ],
                ): const Text("Supply Goods from selected locations \nThis cannot be undone!"),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close'),
                ),
                TextButton(
                  onPressed: () async {
                    processingOrder = true;
                    setState((){});
                    processSupply().then((value) => {
                    orderData["Supplied"] = "Supplied",
                    processingOrder = false,
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black87, content: Text("Order Supplied!", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,)),
                    Navigator.of(context).pop(false)
                    });



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
}
