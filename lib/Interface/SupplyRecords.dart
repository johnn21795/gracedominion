
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gracedominion/Desktop/WidgetClass.dart';
import 'package:gracedominion/Interface/MainInterface.dart';

import '../Classes/LogicClass.dart';
import '../Classes/TableClass.dart';

Size? screenSize;
int totalSales = 0;
int totalAmount = 0;
Map<String, dynamic> selectedOrderData = {};
class SupplyRecord extends StatefulWidget {
  const SupplyRecord({Key? key}) : super(key: key);

  @override
  State<SupplyRecord> createState() => _SupplyRecordState();
}

class _SupplyRecordState extends State<SupplyRecord> {
  bool isTyping = false;
  final cardController = TextEditingController();
  String cardLabel = "Search Customer";
  Color labelColor = WidgetClass.mainColor;
  bool isSearching = false;
  bool isLoading = true;
  DateTime startDate = DateTime.utc(2023);
  DateTime endDate = DateTime.now();
  String? records = "Supply Records";

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: MyFloatingActionButton(
        text: 'Select Date',
        onPressed: () async {
          await showDatePicker(
            firstDate: DateTime.utc(2023),
            initialDate: DateTime.now(),
            lastDate: DateTime.now(),
            context: context,
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ThemeData.light().colorScheme.copyWith(
                    primary: mainColor, // Custom primary color
                    onPrimary: Colors.white, // Custom text color on primary color
                  ),
                ),
                child: child!,
              );
            },
          ).then((value)  {
             if(value == null){
               startDate = DateTime.utc(2023);
               endDate =  DateTime.now();
             }else{
               startDate = endDate = value;
             } }).then((value) => setState((){}));
          



        },
      )
      ,
      body:  Stack(
        children: [
         Positioned(
           top: 50,
           right: 10,
           left: 5,
           child: SizedBox(
               width: screenSize!.width * 0.72,
               height: screenSize!.height * 0.87,
               child: TableClass(
                   tableColumns:  {"No" :ColumnSize.S, "Date":ColumnSize.S, "Name":ColumnSize.S,"Items":ColumnSize.S,"SuppliedDate":ColumnSize.S,"Status":ColumnSize.S},
                   tableName: "Supply",
                   searchQuery:  {"Search":cardController.text.toUpperCase(), "StartDate":startDate, "EndDate":endDate},
                   myFunction: (){
                     showOrderDialog(context, selectedOrderData);
                   }
               )),

         ),


          Positioned(
              left: 15,
              child: Row(
                children: [
                  SizedBox(width:  screenSize!.width * 0.30, child: TextField(
                    onSubmitted: (query){
                      setState(() { });
                    },
                    style: const TextStyle(fontSize: 14),
                    controller: cardController,
                    decoration:  InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: labelColor, width: 2.0),
                        ),
                        suffixIcon: isSearching? Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                          child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child: const CircularProgressIndicator(strokeWidth: 2.0 )),
                        ): const SizedBox(),
                        label: const Text(
                          "Search Order",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              textBaseline: TextBaseline.alphabetic),
                        ),labelStyle: TextStyle(fontSize: 12, color: labelColor)
                    ),
                  )),
                  MyCustomButton(
                      text: "Search",
                      onPressed: (){
                        setState(() { });
                      },
                      icon: Icons.search,
                      size: const Size(130, 38)
                  )
                ],
              )),
          Positioned(
              left: screenSize!.width * 0.43,
              top: 15,
              child: Row(
                children: [
                  Text("${LogicClass.fullDate.format(startDate)}:  ", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.020),),
                  GestureDetector(
                      onTap: () async {
                        await showDatePicker(
                        firstDate: DateTime.utc(2023),
                        initialDate: DateTime.now(),
                        lastDate: DateTime.now(),
                        context: context,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ThemeData.light().colorScheme.copyWith(
                                primary: mainColor, // Custom primary color
                                onPrimary: Colors.white, // Custom text color on primary color
                              ),
                            ),
                            child: child!,
                          );
                        },
                        ).then((value)  {
                          if(value == null){
                            startDate = DateTime.utc(2023);
                          }else{
                            startDate = value;
                          } }).then((value) => setState((){}));
                      },
                      child: Icon(Icons.calendar_month, color: WidgetClass.mainColor,)
                  )
                ],
              )),
          Positioned(
              left: screenSize!.width * 0.60 ,
              top: 15,
              child: Row(
                children: [
                  Text("${LogicClass.fullDate.format(endDate)}: ", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.020),),
                  GestureDetector(
                      onTap: () async {
                         await showDatePicker(
                          firstDate: DateTime.utc(2023),
                          initialDate: DateTime.now(),
                          lastDate: DateTime.now(),
                          context: context,
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ThemeData.light().colorScheme.copyWith(
                                  primary: mainColor, // Custom primary color
                                  onPrimary: Colors.white, // Custom text color on primary color
                                ),
                              ),
                              child: child!,
                            );
                          },
                        ).then((value)  {
                           if(value == null){
                             endDate =  DateTime.now();
                           }else{
                             endDate = value;
                           } }).then((value) => setState((){}));
                      },
                      child: Icon(Icons.calendar_month, color: WidgetClass.mainColor,)
                  )
                ],
              )),
        ]
        ,
      )
      ,
    );
  }
  Future<bool?> showSummaryDialog(BuildContext context) async {
    // Add this variable to track the editing state
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Summary'),
              content:  SizedBox(
                height: screenSize!.height * 0.3,
                    child: Stack(
                      children: [
                        Positioned(top:0, left: 30, child: Text(LogicClass.fullDate.format(startDate), style: const TextStyle(fontFamily: "claredon", fontWeight: FontWeight.bold),)),
                        const Positioned(top:25,left: 100, child: Text("To:")),
                        Positioned(top:50,left: 30, child: Text(LogicClass.fullDate.format(endDate),style: const TextStyle(fontFamily: "claredon", fontWeight: FontWeight.bold))),
                        const Positioned(top:80,left: 80, child: Text('Total Sales:')),
                         Positioned(top:100,left: 100, child: Text('$totalSales', style: const TextStyle(fontFamily: "claredon", fontWeight: FontWeight.bold))),
                        const Positioned(top:145,left: 60, child: Text('Total Amount:')),
                         Positioned(top:170,left: 40, child: SizedBox(width: 150, child: Center(child: Text(LogicClass.returnCommaValue(totalAmount.toString()), style: const TextStyle(fontFamily: "majoris", fontWeight: FontWeight.bold))))),
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

  Future<bool?> showOrderDialog(BuildContext context, Map<String, dynamic> data) async {
    // Add this variable to track the editing state
   int noOfItems = 0;
   print(data);
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
                            Text(data["Phone"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),),
                            SizedBox(
                                width: 250,
                                child: Text(data["Address"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),))
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
                                child: Text("Cs 50 CornerStone Plaza Ojo Lagos", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.013, ),)),
                            SizedBox(
                                child: Text("Thanks for your Patronage...", style: TextStyle(fontFamily: "Claredon", fontStyle: FontStyle.italic , fontSize: screenSize!.height * 0.013, ),))
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


