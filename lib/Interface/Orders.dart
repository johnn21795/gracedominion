
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:gracedominion/Showroom/MainInterface.dart';

import '../Desktop/WidgetClass.dart';
import 'Inventory.dart';
import 'MainInterface.dart';



Size? screenSize;
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

  FocusNode customerNode = FocusNode();
  FocusNode productNode = FocusNode();

  Color labelColor =  WidgetClass.mainColor;
  bool isSearching = false;
  bool viewCustomers = false;
  bool viewProducts = false;
  bool collectPayment = false;
  bool createOrder = false;

  final Map<String, dynamic> items = {
  'CAKE CHILLER HW-848': 21795,
  'ELECTRIC GRIDDLE STANDING WITH CABINET HALF GROOVED HALF SMOOTH BIG': 21795,
  'WORK TABLE WHT-2-712S/BN-W03 4FEET': 21795,
  'Item 4': 21795,
  'Item 5': 21795,
  'Item 6': 21795,
  'Item 7': 21795,
  'Item 8': 21795,
};

  @override
  void initState() {
    super.initState();
    pageLoading = false;
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
      body:  Stack(
        children:[
           Positioned(
            top: 20,
            left: 15,
            child: Text("Customer Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: WidgetClass.mainColor),)),
          Positioned(
              top: 45,
              left: 15,
              child: SizedBox(width: 200, child: TextField(
                focusNode: customerNode,
                onSubmitted: (query){

                },
                onChanged: (card) async {
                  customerController.text.isEmpty ?  viewCustomers = false :  viewCustomers = true;
                  setState(() { });
                },
                style: const TextStyle(fontSize: 14),
                controller: customerController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    suffixIcon: isSearching? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child: const CircularProgressIndicator(strokeWidth: 2.0 )),
                    ): const SizedBox(),
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
                child: MouseRegion(
                  onExit: (event) {
                    print('Mouse exited the SizedBox');
                  },
                  onEnter: (event) {
                    viewCustomers = true;
                  },
                  child: SizedBox(
                    height: screenSize!.height * 0.24,
                    width: 200,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) => Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5FFF5),
                            border: Border.all(color:  WidgetClass.mainColor, width: 1.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:10.0, top:3),
                              child: Text(items.keys.elementAt(index), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:10.0),
                              child: Text("ID: ${items.values.elementAt(index)}",  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic,)),
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
           Positioned(
              top: screenSize!.height * 0.4,
              left: 15,
              child:  Text("Product Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:  WidgetClass.mainColor),)),
          Positioned(
              top: screenSize!.height * 0.4 + 20,
              left: 15,
              child: SizedBox(width: 200, child: TextField(
                focusNode: productNode,
                onSubmitted: (query){

                },
                onChanged: (card) async {
                  productController.text.isEmpty ?  viewProducts = false :  viewProducts = true;
                  setState(() { });
                },
                style: const TextStyle(fontSize: 14),
                controller: productController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    suffixIcon: isSearching? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child: const CircularProgressIndicator(strokeWidth: 2.0 )),
                    ): const SizedBox(),
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
              child: SizedBox(width: 200, child: TextField(
                onSubmitted: (query){

                },
                onChanged: (card) async {
                  setState(() { });
                },
                style: const TextStyle(fontSize: 14),
                controller: priceController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    suffixIcon: isSearching? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child: const CircularProgressIndicator(strokeWidth: 2.0 )),
                    ): const SizedBox(),
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
              child: SizedBox(width: 200, child: TextField(
                onSubmitted: (query){

                },
                onChanged: (card) async {
                  setState(() { });
                },
                style: const TextStyle(fontSize: 14),
                controller: quantityController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: labelColor, width: 2.0),
                    ),
                    suffixIcon: isSearching? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child: const CircularProgressIndicator(strokeWidth: 2.0 )),
                    ): const SizedBox(),
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
              onPressed: (){},
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
                width: 200,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FFF8),
                      border: Border.all(color: const Color(0x33005500), width: 1.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:10.0, top:3),
                          child: Text(items.keys.elementAt(index), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Text("ID: ${items.values.elementAt(index)}",  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic,)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top:15,
              right: screenSize!.width * 0.05,
              child:MyCustomButton(
                  text:  createOrder? "Create Order" :"Cancel Order",
                  onPressed: (){
                    createOrder = !createOrder;
                    setState(() {

                    });
                  },
                  icon: createOrder? FontAwesomeIcons.firstOrder : FontAwesomeIcons.ban,
                  size:  const Size(150,40)
              )
          ),
          Positioned(
              bottom:15,
              right: screenSize!.width * 0.05,
              child:MyCustomButton(
                  text: "Save and Print",
                  onPressed: (){},
                  icon: FontAwesomeIcons.floppyDisk,
                  size:  const Size(150,40)
              )
          ),
          Positioned(
            left:screenSize!.width * 0.21,
            child: Container(
              height: screenSize!.height * 0.92,
              width: screenSize!.width * 0.5,
              decoration: BoxDecoration(
                  color: const Color(0xFFF8FFF8),
                  border: Border.all(color:  WidgetClass.mainColor, width: 1.0),


                ),
                child:
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
                          child: Text("Order No: 2517", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016),)
                      ),
                      Positioned(
                          top:screenSize!.height * 0.06,
                          left: 20,
                          child: Text("Wed May 8th, 2023", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),)
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
                                  child: Text("NIGERIA UNIVERSITY OF TECHNOLOGY", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),)),
                              Text("08143255147", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),),
                              SizedBox(
                                width: 250,
                                  child: Text("Cs 50 CornerStone Plaza, Ojo Alaba Lagos", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),))
                            ],
                          )
                      ),
                      Positioned(
                          top:screenSize!.height * 0.18,
                          left: screenSize!.width * 0.22,
                          child:  Text("Invoice", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.025, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),)
                      ),
                      Positioned(
                          top:screenSize!.height * 0.17,
                          left: 10,
                          child:   Container(height: 50,
                              width:  screenSize!.width * 0.49,
                              alignment: Alignment.bottomCenter,
                              child:  const Divider( height: 10, color: Color(0x99002200), thickness: 2,)),
                      ),
                      Positioned(
                        top:screenSize!.height * 0.65,
                        left: 10,
                        child:   Container(height: 50,
                            width:  screenSize!.width * 0.49,
                            alignment: Alignment.bottomCenter,
                            child:  const Divider( height: 10, color: Color(0x99002200), thickness: 2,)),
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
                                    width:  screenSize!.width * 0.07,
                                    child: Text("Unit Price", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),

                                SizedBox(
                                    width:  screenSize!.width * 0.03,
                                    child: Text("Qty", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),

                                SizedBox(
                                    width:  screenSize!.width * 0.03,
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
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) => Container(
                                width:  screenSize!.width * 0.49,
                                height: screenSize!.height * 0.06,
                                margin: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                                padding: EdgeInsets.zero,

                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5FFF5),
                                  border: Border.all(color:  const Color(0x33005500), width: 1.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Image(
                                      image: AssetImage('assets/images/placeholder.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox( width: screenSize!.width * 0.27,
                                        child: Text("ELECTRIC GRIDDLE STANDING WITH CABINET HALF GROOVED HALF SMOOTH BIG", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),
                                    Text("300,000", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                                    SizedBox(width: screenSize!.width * 0.01,),
                                    Text("4", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                                    SizedBox(width: screenSize!.width * 0.01,),
                                    Text("1,200,000", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w600),),
                                  ],
                                ),
                              ),
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
                                  child: Text("250,00,000", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
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
                                  child: Text("25", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                            ],
                          )
                      ),
                      Positioned(
                          top:screenSize!.height * 0.75,
                          left: 20,
                          child:!collectPayment ? MyCustomButton(
                            text: "Payment",
                            onPressed: (){},
                            icon: FontAwesomeIcons.moneyCheckDollar,
                            size:  Size(screenSize!.width * 0.07, screenSize!.height * 0.04)
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
                                      child: Text("Paid with Transfer", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: screenSize!.width * 0.09,
                                      child: Text("Payment Ref:", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),)),
                                  SizedBox(
                                      width: screenSize!.width * 0.06,
                                      child: Text("23051089", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
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
                )
            )
          ),



        ],
      )
      ,
    );
  }
}
