
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gracedominion/Warehouse/MainInterface.dart';
import 'package:gracedominion/Warehouse/Product.dart';
import 'package:intl/intl.dart';

import '../AppRoutes.dart';
import '../Classes/MainClass.dart';
import '../Classes/TableClass.dart';
import '../Desktop/WidgetClass.dart';


final dateFormat = DateFormat('dd-MM-yyyy');
Size? screenSize;




class InventoryPage extends StatefulWidget {
   final Function() myFunction;
  
  const InventoryPage({Key? key, required this.myFunction}) : super(key: key);
  

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool isTyping = false;
  final cardController = TextEditingController();
  String cardLabel = "Search Inventory";
  Color labelColor = MainInterface.mainColor;
  bool isSearching = false;
  // String activePage = "";


  void changeActivePage(){
    print("Changeing active page");

    widget.myFunction.call();

  }






  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: MyFloatingActionButton(
        text: 'Add New Product',
        onPressed: () {
          activePage = "Product";
          page =  ProductPage(data: {"Name":"test"},);
          changeActivePage();
        },
      ),
      body:  Stack(
        children: [
          Positioned(
            left:10,
            top: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  height: 100,
                  width: screenSize!.width * 0.35,
                  child: TextField(
                    onSubmitted: (query){

                    },
                    onChanged: (card) async {
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
                        label: Text(
                          cardLabel,
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
                    text: "Search",
                    onPressed: (){
                    
                    },
                    icon: Icons.search,
                    size: const Size(130, 38)
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 32,
              right:  screenSize!.width * 0.03,
            child: Container(
              transform: Matrix4.translationValues(0, -30, 0),
              child: MyCustomButton(
                text: "All Products",
                onPressed: (){
                  

                },
                icon: Icons.list_alt_rounded,
                size: const Size(130, 38)
              ),
            ),
          ),
          Positioned(
            top:50,
            child: SizedBox(
              height: screenSize!.height * 0.87 + 20,
                width: screenSize!.width * 0.87,
                child:  TableClass(
                    tableColumns: const {"No" :ColumnSize.S,"Image":ColumnSize.S,"Name":ColumnSize.L,"Category":ColumnSize.M,"SKU":ColumnSize.S,"Quantity":ColumnSize.S,"Comment":ColumnSize.S},
                    tableName: "Inventory",
                    myFunction: changeActivePage))
              // child:  LazyLoadDataTableExample())
            ,
          )
        ],
      )
      ,
    );
  }


}
