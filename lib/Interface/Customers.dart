
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gracedominion/Interface/Product.dart';
import 'package:intl/intl.dart';

import '../Classes/TableClass.dart';
import '../Desktop/WidgetClass.dart';
import 'MainInterface.dart';
import 'Profile.dart';



Size? screenSize;
final dateFormat = DateFormat('dd-MM-yyyy');
class CustomersPage extends StatefulWidget {
  final Function() myFunction;
  const CustomersPage({Key? key, required this.myFunction}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  bool isTyping = false;
  final cardController = TextEditingController();
  String cardLabel = "Search Customer";
  Color labelColor = WidgetClass.mainColor;
  bool isSearching = false;

  void changeActivePage(){
    widget.myFunction.call();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return  Scaffold(
      floatingActionButton: MyFloatingActionButton(
        text: 'Add New Customer',
        onPressed: (){
          pageLoading = true;
          changeActivePage();
          activePage = "Profile";
          print("Fuck!!!!");
          // var productID = await FirebaseClass.getNewProductID();
          page =  Profile();
          pageLoading = false;
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
                      onPressed: (){},
                      icon: Icons.search,
                      size: const Size(130, 38)
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top:50,
            child: SizedBox(
                height: screenSize!.height * 0.87,
                child:  TableClass(tableColumns: const {"No" :ColumnSize.S,"Name":ColumnSize.M,"Phone":ColumnSize.M,"Orders":ColumnSize.S,"Amount Spent":ColumnSize.S,"Balance":ColumnSize.S}, tableName: "Customers", myFunction: (){},)),
          )
        ],
      )
      ,
    );
  }


}

