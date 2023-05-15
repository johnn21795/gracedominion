
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gracedominion/Desktop/WidgetClass.dart';

Size? screenSize;
class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  bool isTyping = false;
  final cardController = TextEditingController();
  String cardLabel = "Search Customer";
  Color labelColor = WidgetClass.mainColor;
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body:  Stack(
        children: [
         Positioned(
           top: 50,
           right: 20,
           child: SizedBox(
               width: screenSize!.width * 0.72,
               height: screenSize!.height * 0.87,
               child: TableClass(tableColumns: {"No" :ColumnSize.S, "Order":ColumnSize.S, "Customer":ColumnSize.M,"Total":ColumnSize.S,"Items":ColumnSize.S,"Invoice No":ColumnSize.S,"Comment":ColumnSize.S}, tableName: "Sales", myFunction: (){})),
         ),

          Positioned(
              top:screenSize!.height * 0.05,
              left: screenSize!.width * 0.025,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("DAILY SALES:", style: TextStyle(fontFamily: "Copper",decoration: TextDecoration.underline, fontSize: screenSize!.height * 0.016, fontWeight: FontWeight.bold),),
                  SizedBox(
                      // width: 250,
                      child: Row(
                        children: [
                          Text("Wed 15th May, 2023", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016),),
                          GestureDetector(
                              onTap: () {
                                showDatePicker(
                                    firstDate: DateTime.utc(2022),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime.now(),
                                    context: context);
                                setState(() {

                                });
                              },
                              child: Icon(Icons.calendar_month, color: WidgetClass.mainColor,)
                          )
                        ],
                      )),
                  SizedBox(height: 10,),
                  Text("N15,000,000", style: TextStyle(fontFamily: "Majoris", fontSize: screenSize!.height * 0.02),),
                  SizedBox(height: 5,),
                  SizedBox(
                      child: Text("18 Orders", style: TextStyle(fontFamily: "", decoration: TextDecoration.underline, fontSize: screenSize!.height * 0.016),))
                ],
              )
          ),
          Positioned(
              top:screenSize!.height * 0.35,
              left: screenSize!.width * 0.025,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("WEEKLY SALES:", style: TextStyle(fontFamily: "Copper",decoration: TextDecoration.underline, fontSize: screenSize!.height * 0.016, fontWeight: FontWeight.bold),),
                  SizedBox(
                    // width: 250,
                      child: Row(
                        children: [
                          Text("Wed 15th May, 2023", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016),),
                          GestureDetector(
                              onTap: () {
                                showDatePicker(
                                    firstDate: DateTime.utc(2022),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime.now(),
                                    context: context);
                                setState(() {

                                });
                              },
                              child: Icon(Icons.calendar_month, color: WidgetClass.mainColor,)
                          )
                        ],
                      )),
                  SizedBox(
                    // width: 250,
                      child: Row(
                        children: [
                          Text("Wed 15th May, 2023", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015),),
                          GestureDetector(
                              onTap: () {
                                showDatePicker(
                                    firstDate: DateTime.utc(2022),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime.now(),
                                    context: context);
                                setState(() {

                                });
                              },
                              child: Icon(Icons.calendar_month, color: WidgetClass.mainColor,)
                          )
                        ],
                      )),
                  SizedBox(height: 10,),
                  Text("N15,000,000", style: TextStyle(fontFamily: "Majoris", fontSize: screenSize!.height * 0.02),),
                  SizedBox(height: 5,),
                  SizedBox(
                      child: Text("18 Orders", style: TextStyle(fontFamily: "", decoration: TextDecoration.underline, fontSize: screenSize!.height * 0.016),))
                ],
              )
          ),
          Positioned(
              top:screenSize!.height * 0.65,
              left: screenSize!.width * 0.025,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("MONTHLY SALES:", style: TextStyle(fontFamily: "Copper",decoration: TextDecoration.underline, fontSize: screenSize!.height * 0.016, fontWeight: FontWeight.bold),),
                  SizedBox(
                    // width: 250,
                      child: Row(
                        children: [
                          Text("May 2023", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016),),
                          GestureDetector(
                              onTap: () {
                                showDatePicker(
                                    firstDate: DateTime.utc(2022),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime.now(),
                                    context: context);
                                setState(() {

                                });
                              },
                              child: Icon(Icons.calendar_month, color: WidgetClass.mainColor,)
                          )
                        ],
                      )),
                  SizedBox(height: 10,),
                  Text("N15,000,000", style: TextStyle(fontFamily: "Majoris", fontSize: screenSize!.height * 0.02),),
                  SizedBox(height: 5,),
                  SizedBox(
                      child: Text("18 Orders", style: TextStyle(fontFamily: "", decoration: TextDecoration.underline, fontSize: screenSize!.height * 0.016),))
                ],
              )
          ),
          Positioned(
              right: screenSize!.width * 0.375,
              child: SizedBox(width:  screenSize!.width * 0.35, child: TextField(

                onSubmitted: (query){

                },
                onChanged: (card) async {
                  // customerController.text.isEmpty ?  viewCustomers = false :  viewCustomers = true;
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
              ))),
          Positioned(
            top:10,
            right: screenSize!.width * 0.28,
            child: MyCustomButton(
                text: "Search",
                onPressed: (){},
                icon: Icons.search,
                size: const Size(130, 38)
            ),
          ),

        ]
        ,
      )
      ,
    );
  }

}


