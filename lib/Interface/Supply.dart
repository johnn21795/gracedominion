
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gracedominion/Showroom/MainInterface.dart';

import '../Desktop/WidgetClass.dart';
import 'Inventory.dart';


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

  Color labelColor = MainInterface.mainColor;
  bool isSearching = false;
  bool viewCustomers = false;
  bool viewProducts = false;
  bool collectPayment = false;
  bool createOrder = false;




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
  Map<String, dynamic> items = {
    'CAKE CHILLER HW-848': 21795,
    'ELECTRIC GRIDDLE STANDING WITH CABINET HALF GROOVED HALF SMOOTH BIG': 21795,
    'WORK TABLE WHT-2-712S/BN-W03 4FEET': 21795,
    'Item 4': 21795,
    'Item 5': 21795,
    'Item 6': 21795,
    'Item 7': 21795,
    'Item 8': 21795,
  };
  List<String?> selectedValues = List.generate(8, (_) => null);

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body:  Stack(
        children:[
          Positioned(
            left:10,
            top: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  height: 100,
                  width: screenSize!.width * 0.1,
                  child: TextField(
                    onSubmitted: (query){

                    },
                    onChanged: (card) async {
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
                        label: Text(
                          "Order No",
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              textBaseline: TextBaseline.alphabetic),
                        ),labelStyle: TextStyle(fontSize: 12, color: labelColor)
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Container(
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: MyCustomButton(
                      text: "Load",
                      onPressed: (){
                          createOrder = !createOrder;
                          print("Create 2 order $createOrder");
                          setState(() {

                          });
                        },
                      icon: Icons.label,
                      size: const Size(100, 35)
                  ),
                ),
              ],
            ),
          ),

          Positioned(
              bottom:15,
              right: screenSize!.width * 0.05,
              child:MyCustomButton(
                  text: "Save and Supply",
                  onPressed: (){},
                  icon: FontAwesomeIcons.floppyDisk,
                  size:  const Size(170,40)
              )
          ),
          Positioned(
            left:screenSize!.width * 0.21,
            child: Container(
              height: screenSize!.height * 0.92,
              width: screenSize!.width * 0.5,
              decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FF),
                  border: Border.all(color: MainInterface.mainColor, width: 1.0),

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
                          child: Row(
                            children: [
                              Text("Order No: ", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016),),
                              Text("2517", style: TextStyle(fontFamily: "Claredon", fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.016),),
                            ],
                          )
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
                                    width:  screenSize!.width * 0.35,
                                    child: Text(" \t\t\t Product Details", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),


                                SizedBox(
                                    width:  screenSize!.width * 0.04,
                                    child: Text("Qty", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),
                                SizedBox(width: screenSize!.width * 0.001,),
                                SizedBox(
                                    width:  screenSize!.width * 0.07,
                                    child: Text("Supply From", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),

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
                                  color: const Color(0xFFF5F5FF),
                                  border: Border.all(color:  const Color(0x33000055), width: 1.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Image(
                                      image: AssetImage('assets/images/profile.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox( width: screenSize!.width * 0.27,
                                        child: Text("ELECTRIC GRIDDLE STANDING WITH CABINET HALF GROOVED HALF SMOOTH BIG", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),

                                    // SizedBox(width: screenSize!.width * 0.01,),
                                    Text("4", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                                    SizedBox(width: screenSize!.width * 0.01,),
                                    Center(
                                      child: DropdownButton(
                                        isExpanded: false,
                                        value:  selectedValues[index],
                                        items: [
                                          "Warehouse",
                                          "Showroom",
                                        ].map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item, style: TextStyle( fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                                        ))
                                            .toList(),
                                        onChanged: (string) {
                                          print("string $string");
                                          selectedValues[index] = string;
                                          setState((){});
                                        },
                                        // onChanged: null,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
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
                          child:collectPayment ? MyCustomButton(
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
                                      child: Text("Confirmed", style: TextStyle(fontFamily: "Claredon", color: Colors.green, fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold),))
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
