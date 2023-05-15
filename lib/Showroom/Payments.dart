
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../Desktop/WidgetClass.dart';

Size? screenSize;
class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isTyping = false;
  final cardController = TextEditingController();
  String cardLabel = "Search Payment";
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
            left:15,

            child: SizedBox(
                width: screenSize!.width * 0.9,
                height: screenSize!.height * 0.87,
                child: TableClass(tableColumns: {"No" :ColumnSize.S, "Reference":ColumnSize.S, "Customer":ColumnSize.M,"Amount":ColumnSize.S,"Order":ColumnSize.S,"Status":ColumnSize.S,"Comment":ColumnSize.S}, tableName: "Sales", myFunction: (){})),
          ),


          Positioned(
              left:15,
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
                      "Search Payments",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic),
                    ),labelStyle: TextStyle(fontSize: 12, color: labelColor)
                ),
              ))),
          Positioned(
            top:10,
            left: screenSize!.width * 0.38,
            child: MyCustomButton(
                text: "Search",
                onPressed: (){},
                icon: Icons.search,
                size: const Size(130, 38)
            ),
          ),
          Positioned(
               top:20,
              right: screenSize!.width * 0.03,
              child: SizedBox(
                // width: 250,
                  child: Row(
                    children: [
                      Text("Wed 15th May, 2023", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.018),),
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
                  ))
          ),

        ]
        ,
      )
      ,
    );
  }
}
