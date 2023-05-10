
import 'package:flutter/material.dart';
import 'package:gracedominion/Showroom/MainInterface.dart';

import 'Inventory.dart';


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

  Color labelColor = MainInterface.mainColor;
  bool isSearching = false;
  bool viewCustomers = false;
  bool viewProducts = false;

  final Map<String, dynamic> items = {
  'Chukwuedo James': 21795,
  'Item 2': 21795,
  'Item 3': 21795,
  'Item 4': 21795,
  'Item 5': 21795,
  'Item 6': 21795,
  'Item 7': 21795,
  'Item 8': 21795,
};

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
      body:  Stack(
        children:[
          const Positioned(
            top: 20,
            left: 15,
            child: Text("Customer Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MainInterface.mainColor),)),
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
                            border: Border.all(color: MainInterface.mainColor, width: 1.0),
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
              child: const Text("Product Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MainInterface.mainColor),)),
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
                      color: const Color(0xFFF5FFF5),
                      border: Border.all(color: MainInterface.mainColor, width: 1.0),
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


        ],
      )
      ,
    );
  }
}
